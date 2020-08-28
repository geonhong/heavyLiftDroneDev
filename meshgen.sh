#!/bin/bash

./sectgen/sectgen.py

m4 -I constant/section system/blockMeshDict.m4 > system/blockMeshDict
blockMesh

mirrorMesh -overwrite
