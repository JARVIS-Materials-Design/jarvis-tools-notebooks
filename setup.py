import glob
import os

from setuptools import setup, find_packages

JARVIS_DIR = os.path.dirname(os.path.abspath(__file__))

base_dir = os.path.dirname(__file__)
with open(os.path.join(base_dir, "README.md")) as f:
    long_d = f.read()

setup(
    name="jarvis-tools-notebooks",
    version="2020.6.13",
    long_description=long_d,
    install_requires=[
        "jarvis-tools",
    ],

    extras_require={
        "ai": ["torch","keras","tensorflow","scikit-learn", "flask","pandas"],
        "babel": ["openbabel", "pybel"],
        "doc": ["sphinx>=1.3.1", "sphinx-rtd-theme>=0.1.8"], 
    },
    author="Kamal Choudhary",
    author_email="kamal.choudhary@nist.gov",
    description=(
        "Collection of Jupyter/ Google-Colab notebooks used in the NIST-JARVIS infrastructure. https://jarvis.nist.gov/"
    ),
    license="NIST",
    url="https://github.com/knc6/jarvis-tools-notebooks",
    packages=find_packages(),
    # long_description=open(os.path.join(os.path.dirname(__file__), "README.rst")).read(),
    classifiers=[
        "Programming Language :: Python :: 3.6",
        "Development Status :: 4 - Beta",
        "Intended Audience :: Science/Research",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
        "Topic :: Scientific/Engineering",
    ],
    # scripts=glob.glob(os.path.join(JARVIS_DIR,  "*"))
)
