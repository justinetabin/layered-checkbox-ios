# LayeredCheckbox
[![Build Status](https://travis-ci.com/justinetabin/layered-checkbox-ios.svg?branch=master)](https://travis-ci.com/justinetabin/layered-checkbox-ios)
[![codecov](https://codecov.io/gh/justinetabin/layered-checkbox-ios/branch/master/graph/badge.svg)](https://codecov.io/gh/justinetabin/layered-checkbox-ios)

An example app of 3 levels and 3 states checkboxes.

### Layers
- `L1`: This will be the top most level. It will have `L2` & `L3` as Childs hence maintain its state based upon Childs selections. 
- `L2`: This will be second level. It will have `L3` as Childs & `L1` as parent hence maintain its state based upon both parent & Childs selections. 
- `L3`: This will be the third level. It will have `L2` & `L1` both as parent hence maintain its state based upon both parents selections. Also, as it’s the last level in the tree so it doesn’t have indeterminate selection. 

### States
- `None`: This state represents that Checkbox is not selected.
- `Indeterminate`: This state represents the Checkbox is partially selected. 
- `Checked`: This state represents the Checkbox is fully selected. 

# Architecture Overview
This project's architecture highlights separation of concerns.

### Service Layer
- Encapsulates the interaction between 3rd party service or API.

### Worker Layer
- Encapsulates the complex business or presentation logic and make them reusable.

### Scene Layer
- The UI that can be easily added or swapped in and out without changing any business logic.
