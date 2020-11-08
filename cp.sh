#!/bin/bash

make clean html
rm -rf docs/**
touch docs/.nojekyll
cp -r build/html/* docs/
