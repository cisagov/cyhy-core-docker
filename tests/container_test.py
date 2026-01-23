"""Tests for example container."""

# Standard Python Libraries
import os
import time

# Third-Party Libraries
import pytest
import semver

READY_MESSAGE = "Package"
RELEASE_TAG = os.getenv("RELEASE_TAG")
VERSION_FILE = "src/version.txt"


def test_container_count(dockerc):
    """Verify the test composition and container."""
    # all parameter allows non-running containers in results
    assert (
        len(dockerc.compose.ps(all=True)) == 1
    ), "Wrong number of containers were started."


def test_wait_for_ready(main_container):
    """Wait for container to be ready."""
    TIMEOUT = 10
    for i in range(TIMEOUT):
        if READY_MESSAGE in main_container.logs():
            break
        time.sleep(1)
    else:
        raise Exception(
            f"Container does not seem ready.  "
            f'Expected "{READY_MESSAGE}" in the log within {TIMEOUT} seconds.'
        )


def test_wait_for_exits(dockerc, main_container):
    """Wait for containers to exit."""
    assert (
        dockerc.wait(main_container.id) == 0
    ), "Container service (main) did not exit cleanly"


def test_output(dockerc, main_container, project_version):
    """Verify the container had the correct output."""
    # make sure container exited if running test isolated
    dockerc.wait(main_container.id)
    log_output = main_container.logs()
    log_output_lines = log_output.splitlines()
    cyhy_core_version = None
    for line in log_output_lines:
        if line.startswith("cyhy-core"):
            cyhy_core_version = line.strip().split(" ")[-1]
            break

    assert cyhy_core_version is not None, "cyhy-core version not found in log output"
    assert cyhy_core_version == semver.version.Version.parse(
        project_version
    ), "cyhy-core version in log does not match project version"


@pytest.mark.skipif(
    RELEASE_TAG in [None, ""], reason="this is not a release (RELEASE_TAG not set)"
)
def test_release_version(project_version):
    """Verify that release tag version agrees with the module version."""
    assert (
        RELEASE_TAG == f"v{project_version}"
    ), "RELEASE_TAG does not match the project version"
