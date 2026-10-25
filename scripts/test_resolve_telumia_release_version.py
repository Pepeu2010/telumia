import unittest

from resolve_telumia_release_version import next_prerelease, parse_version, resolve


class TelumiaReleaseVersionTests(unittest.TestCase):
    def test_increments_existing_alpha_and_android_version_code(self):
        self.assertEqual(
            resolve("1.0.2-alpha.3", "10008", "1.0.2-alpha.3", "10008"),
            ("1.0.2-alpha.4", 10009),
        )

    def test_keeps_a_newer_source_version_and_increments_code_if_needed(self):
        self.assertEqual(
            resolve("1.0.2-alpha.4", "10008", "1.0.2-alpha.3", "10008"),
            ("1.0.2-alpha.4", 10009),
        )

    def test_a_stable_release_starts_the_next_patch_alpha(self):
        self.assertEqual(next_prerelease("1.0.1"), "1.0.2-alpha.1")
        self.assertEqual(
            resolve("1.0.1", "10007", "1.0.1", "10007"),
            ("1.0.2-alpha.1", 10008),
        )

    def test_android_prerelease_order_matches_release_order(self):
        self.assertLess(parse_version("1.0.2-alpha.9"), parse_version("1.0.2-beta.1"))
        self.assertLess(parse_version("1.0.2-beta.9"), parse_version("1.0.2"))
        self.assertLess(parse_version("1.0.2-alpha.9"), parse_version("1.0.3-alpha.1"))

    def test_rejects_invalid_versions_and_codes(self):
        with self.assertRaises(ValueError):
            resolve("1.0", "100", "1.0.0", "100")
        with self.assertRaises(ValueError):
            resolve("1.0.0", "0", None, None)
        with self.assertRaises(ValueError):
            resolve("1.0.0", "100", "1.0.0", "2100000000")


if __name__ == "__main__":
    unittest.main()

