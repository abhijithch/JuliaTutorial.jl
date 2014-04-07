# JuliaTutorial

[![Build Status](https://travis-ci.org/abhi123link/JuliaTutorial.jl.png)](https://travis-ci.org/abhi123link/JuliaTutorial.jl)

This is a Julia based tutorial covering the following topics:

* Introduction to Linear Algebra
* Applications of Matrix Factorizations
* Introduction to Text Mining 
* Introduction to Recommender Systems

This package has each of the above mentioned topics as sub-modules. However as of now only Text Mining tutorial is available, and the rest are under way. 

# Installation
This is an unregistered package, and can be installed in either of the following two ways:

```
Pkg.clone(https://github.com/abhi123link/JuliaTutorial.jl.git)
```
alternatively, this also could be directly cloned from github as follows,
```
git clone https://github.com/abhi123link/JuliaTutorial.jl.git
```
in which case the dependent packages will have to be installed. If installed through the package manager, ```Pkg.clone()``` the dependent packages would be automatically installed. 

# Usage
To start using the package, first do ```using JuliaTutorial```. Then according to the options given, include the sub-modules by ```using JuliaTutorial.Textmining``` to enable all the functions of Text Mining tutorial. 

# Text Mining
=============

Please refer to docs/Julia_TextMining.pdf for the theoretical concepts. 
 
