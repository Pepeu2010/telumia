#!/usr/bin/env python3
"""Choose a monotonically increasing Android prerelease version for Telumia."""

from __future__ import annotations

import argparse
import re
import sys
from dataclasses import dataclass


VERSION_PATTERN = re.compile(
    r"(?P<major>0|[1-9][0-9]*)\."
    r"(?P<minor>0|[1-9][0-9]*)\."
    r"(?P<patch>0|[1-9][0-9]*)"
    r"(?:-(?P<channel>alpha|beta)\.(?P<sequence>[1-9][0-9]*))?"
)
MAX_ANDROID_VERSION_CODE = 2_100_000_000


@dataclass(frozen=True, order=True)
class Version:
    major: int
    minor: int
    patch: int
    channel_rank: int
    sequence: int


def parse_version(value: str) -> Version:
    match = VERSION_PATTERN.fullmatch(value)
    if match is None:
        raise ValueError(f"Invalid Telumia version: {value}")
    channel = match.group("channel")
    return Version(
        major=int(match.group("major")),
        minor=int(match.group("minor")),
        patch=int(match.group("patch")),
        channel_rank={"alpha": 0, "beta": 1, None: 2}[channel],
        sequence=int(match.group("sequence") or 0),
    )


def next_prerelease(value: str) -> str:
    match = VERSION_PATTERN.fullmatch(value)
    if match is None:
        raise ValueError(f"Invalid Telumia version: {value}")

    major, minor, patch = (int(match.group(key)) for key in ("major", "minor", "patch"))
    channel = match.group("channel")
    sequence = match.group("sequence")
    if channel is not None and sequence is not None:
        return f"{major}.{minor}.{patch}-{channel}.{int(sequence) + 1}"
    return f"{major}.{minor}.{patch + 1}-alpha.1"


def positive_integer(value: str, label: str) -> int:
    try:
        number = int(value)
    except ValueError as error:
        raise ValueError(f"{label} must be a positive integer") from error
    if number <= 0 or number > MAX_ANDROID_VERSION_CODE:
        raise ValueError(f"{label} must be between 1 and {MAX_ANDROID_VERSION_CODE}")
    return number


def resolve(source_version: str, source_code: str, published_version: str | None, published_code: str | None) -> tuple[str, int]:
    source_key = parse_version(source_version)
    source_code_value = positive_integer(source_code, "Source versionCode")

    if published_version is None or published_code is None:
        return source_version, source_code_value

    published_key = parse_version(published_version)
    published_code_value = positive_integer(published_code, "Published versionCode")
    if source_key > published_key:
        target_version = source_version
    else:
        target_version = next_prerelease(published_version)

    target_code = max(source_code_value, published_code_value + 1)
    if target_code > MAX_ANDROID_VERSION_CODE:
        raise ValueError("The Android versionCode limit has been reached")
    return target_version, target_code


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source-version", required=True)
    parser.add_argument("--source-code", required=True)
    parser.add_argument("--published-version")
    parser.add_argument("--published-code")
    args = parser.parse_args()

    if bool(args.published_version) != bool(args.published_code):
        parser.error("--published-version and --published-code must be provided together")

    try:
        version, version_code = resolve(
            args.source_version,
            args.source_code,
            args.published_version,
            args.published_code,
        )
    except ValueError as error:
        print(error, file=sys.stderr)
        return 2

    print(f"version={version}")
    print(f"version_code={version_code}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
