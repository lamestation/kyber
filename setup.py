from setuptools import setup, find_packages

with open('README.rst') as f:
        long_description = f.read()

#import subprocess
#version = subprocess.check_output(['git','describe','--tags']).strip()
#
setup(
        name = "kyber",
        version = '0.1.0',
        author = "LameStation",
        author_email = "contact@lamestation.com",
        description = "A publishing toolchain for Confluence",
        long_description = long_description,
        license = "GPLv3",
        url = "https://github.com/lamestation/kyber",
        keywords = "confluence documentation generation wiki pdf html export space",
        packages=find_packages(),
        include_package_data=True,
        entry_points={
            'console_scripts': [
                'kyber = kyber.main:console',
                ],
            },
        classifiers=[
            "Environment :: Console",
            "Development Status :: 2 - Pre-Alpha",
            "Topic :: Utilities",
            "Topic :: Documentation",
            "Topic :: Software Development :: Documentation",
            "Topic :: Text Processing :: Markup",
            "Topic :: Text Processing :: Markup :: HTML",
            "Topic :: Utilities",
            "License :: OSI Approved :: GNU General Public License v3 (GPLv3)",
            "Programming Language :: Python :: 2 :: Only",
            "Programming Language :: Python :: 2.7",
            ]
        )
