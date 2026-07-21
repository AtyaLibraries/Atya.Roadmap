# ATYA-014 implementation evidence

Date: 2026-07-21

Public issue: [ProblemDetails #33](https://github.com/AtyaLibraries/ProblemDetails/issues/33)

Product pull request: [ProblemDetails #35](https://github.com/AtyaLibraries/ProblemDetails/pull/35)

## Result

ATYA-014 is in review. The ProblemDetails product pull request applies one
shared 5xx detail policy to exception and Result mappings. Result-based
responses with statuses from 500 through 599 now use the established generic
detail by default and omit error-derived code and validation extensions.
Request-generated trace and correlation identifiers remain available.

Existing non-5xx Result behavior is unchanged. Applications retain the
existing `MapError` detail factory as the explicit reviewed override for one
documented public detail; error-derived extensions remain redacted on 5xx
responses. No public API was added or changed.

## Sanitized acceptance evidence

- The full ProblemDetails test suite passes: 111 tests.
- Focused synthetic-marker, exception-path, TestServer serialization, 5xx
  boundary, explicit-override, 4xx compatibility, and host-isolation coverage
  passes.
- Coverage is 100% line and 94.15% branch.
- Locked restore, Release build, Release pack, formatting, and diff checks pass.
- Package API compatibility reports no breaking changes.
- The public product diff and pull-request text contain no private evidence or
  reproduction material.

## Compatibility, migration, security, and rollback

This is an intentional behavioral change for Result-based 5xx response bodies
from ProblemDetails version 1.1.0 and earlier. Most applications require no
migration. A client with an approved dependency on a public 5xx detail can use
a narrow `MapError` detail factory that returns only documented content.

The secure default prevents Result error messages and nested validation data
from crossing the 5xx response boundary. Before publication, rollback is a
normal revert of the isolated product commit. After publication, recovery uses
a reviewed forward package update; published packages and tags remain
immutable.

## Remaining work

The product and Roadmap pull requests require review and green CI. ATYA-014
remains open and must not move to Done until both changes merge and post-merge
acceptance is verified. Dependent Project items remain unchanged during review.
