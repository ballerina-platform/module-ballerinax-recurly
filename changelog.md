# Changelog

All notable changes to this project will be documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed

- Regenerated the connector from the Recurly V3 API (`v2021-02-25`) covering all 197 operations. Client methods are now remote functions with camelCase names and typed records; code written against 1.x must be migrated.
- The minimum supported Ballerina distribution is Swan Lake Update 12 (2201.12.0).

### Fixed

- Plan, item and coupon code constraints no longer reject valid values.
