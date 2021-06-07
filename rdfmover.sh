#!/bin/bash

rdf_bake(){
	mkdir rdf
	mv rdf*xvg rdf
	mv *real.ndx rdf
 }

cd D*n12
rdf_bake

cd ../T*d11
rdf_bake

cd ../T*d21
rdf_bake

cd ../M*
rdf_bake

cd ../T*n21
rdf_bake

cd ../T*n11
rdf_bake


