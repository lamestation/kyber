import os

parsers = os.listdir(".")
if "__init__.py" in parsers: parsers.remove("__init__.py")
parsers = [os.path.splitext(x)[0] for x in parsers]
__all__ = parsers
