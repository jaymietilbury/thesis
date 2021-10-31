# Distinguishing adaptation-capable complex networks with oscillatory stimuli - supplementary code

All files have been split up into folders for each network architecture investigated in the project, where for each structure there is a 'single run' file and a 'cycle run' file. The single run file will perform a singular run of the solution with the provided parameters, and then plot the resulting output from each of the nodes. The cycle run file performs runs of the solution with all combinations of parameters entered, and outputs the responses as a table and excel file. Each of the model folders also contains files 'Input', 'interpret_results' and 'reduction_check', which determine the response of the system's output.

The following models are contained in the files:
- IFFL 1
- IFFL 2
- IFFL theta
- NFL 1
- NFL 2
- NFL theta
- RPA IFFL Hill
- RPA IFFL Original
- RPA IFFL theta
- RPA NFL Hill
- RPA NFL Original
- RPA NFL theta

A good starting place is to choose a model (e.g. RPA NFL Hill) and use the single run file to look at the influence of the different parameters.
