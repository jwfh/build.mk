#!/usr/bin/env python3

import configparser
import json
import os
import shutil
import sys
from functools import partial
import re

PROFILE_TRANSFORMATIONS = {}

CREDENTIALS_FILE = os.path.expanduser("~/.aws/credentials")


class Credentials:
    def __init__(self, file_name: str = CREDENTIALS_FILE):
        self._file_name = file_name
        self._config = configparser.ConfigParser()
        if os.path.isfile(self._file_name):
            with open(self._file_name, "r") as istream:
                self._config.read_file(istream)

    def add_section(self, section_name) -> None:
        if not self._config.has_section(section_name):
            self._config.add_section(section_name)

    def set(self, section_name, option, value) -> None:
        self.add_section(section_name)
        self._config.set(section_name, option, value)

    def write(self):
        if os.path.exists(self._file_name):
            shutil.copy(self._file_name, f"{self._file_name}.bak")
        with open(self._file_name, "w") as ostream:
            self._config.write(ostream, space_around_delimiters=True)


def main() -> None:
    awsresponse = json.load(sys.stdin)
    session_name = awsresponse["AssumedRoleUser"]["AssumedRoleId"].split(":")[-1]

    profile_name = session_name
    for transform in [
        f
        for fname, f in PROFILE_TRANSFORMATIONS.items()
        if re.match(fname, profile_name) is not None
    ]:
        profile_name = transform(profile_name)

    credentials = Credentials()

    credentials.set(
        profile_name, "aws_access_key_id", awsresponse["Credentials"]["AccessKeyId"]
    )
    credentials.set(
        profile_name,
        "aws_secret_access_key",
        awsresponse["Credentials"]["SecretAccessKey"],
    )
    credentials.set(
        profile_name, "aws_session_token", awsresponse["Credentials"]["SessionToken"]
    )

    credentials.write()


if __name__ == "__main__":
    main()
