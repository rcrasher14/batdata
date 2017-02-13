# README - batdata
##R code for statistical analysis of bat data.
___

###Overview:
This repo manages R scripts used in collaboration with Virginia Tech graduate student research in 2016-2017.  The subject is bat populations in the DC area.  Data is gathered by deploying sound recording devices across a region, and then post processing is used to determine if a given species' call was heard on a given day.  If post processing determines, with a p-value of < .05, that a species' call was heard on a given day, then we assume the species was present (1).  Otherwise we assume it was not (0).

Raw data is not stored in this repo.

###File Structure Assumptions:
- The repo is stored in a folder called '/scripts'
- It's parent folder has two other subfolders: '/data' and '/plots'

###Getting Started:
1. The [`setup.R`](https://github.com/rcrasher14/batdata/blob/master/setup.R) script is where it all begins.  This script imports raw data and sets ups the basic data structure.
  * It also calls [`vtech_functions.R`](https://github.com/rcrasher14/batdata/blob/master/vtech_functions.R) to instantiate home-grown functions for this project.
2. The heart of the project is [`vtech_functions.R`](https://github.com/rcrasher14/batdata/blob/master/vtech_functions.R).  This is where the home grown scripts are stored.
3. The first set of instantiation code is saved in [`multi_dim_data.R`](https://github.com/rcrasher14/batdata/blob/master/multi_dim_data.R).  This takes the raw data and recasts it into a multi-dimensional list: species -> instance -> presence data (by date).  It also contains code focusing on the number of days (nights actually since bats are nocturnal) where presence was not observed between nights when presence was observed.  Plots are included at the end.
  * This script requires `setup.R` and `vtech_functions.R`
4. The next set of instantiation code focuses on Julian calendar days, and finds the number of negative nights from each date until the next positive observation night.  That code is saved in [`distance_to_one.R`](https://github.com/rcrasher14/batdata/blob/master/distance_to_one.R).  *This is a work in progress*
