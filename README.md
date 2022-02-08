# PURPOSE

This is a small project to implement a pretty good privacy plugin for Netlogo.
An explanation of the structure and the files of this project resides in
MANIFEST.md (NOT manifest.txt, which is used to create the plugin jar).

Essentially this project has three parts.

1. A directory `paper` containing a paper describing the plugin and all the
   files used to develop and publish that paper (markdown and makefiles).
2. A directory `test` containing a very simple NetLogo model to demonstrate the
   use of the plugin.
3. The remainder is the  code and supporting files used to develop the plugin.

# MANIFEST

# INSTALLATION

The plugin is built with `sbt` - Scala Build Tool. This tool is invoked from
the command line and typing `help` at the command line which, unsurprisingly
shows help topics. However using `sbt` essentially boils down to an iteration
of the following:

1. <edit the file elsewhere>
2. `compile`
3. `package`
4. `release`
5. `netlogo`

`package` creates a jar, `release` copies the jar to the correct directory in
the demo Netlogo model, and `netlogo` invokes the Netlogo code.

`compile` and `package` are native `sbt` commands. I have provided `release`
and `netlogo` to allow rapid devlopment iteration, and there are underlying
versions of these to run in either a Windows or Linux environment.

The build file definition `build.sbt` and the command files used are all in
this current directory. 

# UPGRADING

This is for upgrading the package when NetLogo does.

1. Change the `manifest.txt` file and update the NetLogo versions
2. Copy the new Netlogo jar into lib and delete the old ones.
3. 
4. Launch sbt and compile,build, release and run netlogo

# INSTRUCTIONS

<!-- Cut below this line and add into the Notes section of the demo Netlogo model, cbr.nlogo -->

## WHAT IS IT?

This is a small program to show how the look up table extension works.

A look up table is of the structure

Dimension_1    Dimension_2     Dimension_3 
Dim_1_symbol_1 Dim_2_symbol_1  Dim_3_symbol outcome_1

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

### new

Creates a lookup table.

A lookup table.

This look up table definition file looks is made of the following atoms.


```
group_name_1 (group)
	dimension_1 (dimension)
		dimension_1_value_1 (value)
		dimension_1_value_2
		...
	dimension_2
	   	dimension_2_value_1
		dimension_2_value_2
		...
	...
group_name_2
	dimension_3_value_1
	...
...

```

where the spaces _must_ be tabs (so check your editor does not replace tabs with spaces). Atoms may only contain numeric and alphabetic upper case or lower case letters. There are case sensitive.


That is there are *values* which are the nominals for a *dimension* a dimension belongs to a *group*. *group*

#### Parameters

+ *Table definition file* This contains a space delimited definition file for the look up table.

+ *Data file* This is space delimited file contain values in the form of a standard CSV where commas have been replaced with spaces. This of course means that dimensions may 

#### Returns

A lookup table (lookup table object).

### dimensions

Returns a list of possible dimensions from the lookup table definition file.

#### Parameters

+ A look up table (lookup table object)

#### Returns

A list of dimension names. (list)

### first-dimension

Reset a dimenension iterator over a lookup table definition file to the first dimension

#### Parameters

+ Table definition file (lookup table object)

#### Returns

Nothing.

### get-dimension

Gets the next dimension in the lookup table definition file.

#### Parameters

+ Table definition file (lookup table object)

#### Returns

The dimension name (string).

### more-dimensions?

Returns true if the are more dimensions in lookup table definition file to inspect, false otherwise.

#### Parameters

+ Table definition file (lookup table object)

#### Returns

True or False.

### symbols

Returns a list of symbols from a lookup table definition file.

#### Parameters

+ Table definition file (lookup table object)

+ Dimension (string)

#### Returns

A lookup table.

### first-symbol

#### Parameters

+ A look up table (lookup table object)

#### Returns

### get-symbol

#### Parameters

+ A look up table (lookup table object)

#### Returns

A lookup table.

### more-symbols?

#### Parameters

+ A look up table (lookup table object)

#### Returns

A lookup table.

### get 

#### Parameters

+ A look up table (lookup table object)

#### Returns

A lookup table.

### states

#### Parameters

+ A look up table (lookup table object)

#### Returns

A lookup table.

### first-state

#### Parameters

+ A look up table (lookup table object)

#### Returns

A lookup table.

### get-state

#### Parameters

+ A look up table (lookup table object)

#### Returns

A lookup table.

### more-states?

#### Parameters

+ A look up table (lookup table object)

#### Returns


### group

#### Parameters

+ A look up table (lookup table object)

#### Returns

A lookup table.

### set 

#### Parameters

+ A look up table (lookup table object)

#### Returns

A lookup table.

### default

Set the default value returned
#### Parameters

+ A look up table (lookup table object)

#### Returns

Nothing

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)

