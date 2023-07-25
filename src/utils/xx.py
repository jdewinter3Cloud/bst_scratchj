# -*- coding: utf-8 -*-
"""
Module to...
"""

import argparse
import os
import sys
import xml.etree.ElementTree as ET  # nosec B405


# pylint: disable=too-few-public-methods
class Main:
    """
    Class to...
    """

    __RAW_HELP_DESCRIPTION = "bob"

    def __init__(self) -> None:
        self.__coverage_file = ""

    @staticmethod
    def __verify_file_exists(input_value: str) -> str:
        if not os.path.isfile(input_value):
            raise ValueError("File '{input_value}' is not an existing file.")
        return input_value

    def __parse_arguments(self) -> None:

        parser = argparse.ArgumentParser(
            formatter_class=argparse.RawDescriptionHelpFormatter,
            description=Main.__RAW_HELP_DESCRIPTION,
        )
        parser.add_argument(
            "--coverage-file",
            dest="coverage_file",
            action="store",
            required=True,
            help="Coverage file produced after executing tests.",
            type=Main.__verify_file_exists,
        )

        args = parser.parse_args()
        self.__coverage_file = args.coverage_file

    def main(self) -> None:
        """
        Mainline of the script.
        """
        try:
            self.__parse_arguments()
        except (ValueError, TypeError) as err:
            print("ERROR", err, file=sys.stderr)
            sys.exit(1)

        tree = ET.parse(self.__coverage_file)  # nosec B314
        root = tree.getroot()
        for package_item in root.findall(".//package"):
            print(package_item.attrib["name"])


# pylint: enable=too-few-public-methods


if __name__ == "__main__":
    Main().main()
