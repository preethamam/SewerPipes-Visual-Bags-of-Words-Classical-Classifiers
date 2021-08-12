%% Get the testing labels 
% Load the labels 
load ZZZ_ds_combo_1.mat

% Change target labels to match the training labels 
targetTest{1} = changeLabels2matchTrain(imdsTrainRandomized.Labels, imdsTestRandomized_LADWP.Labels);
targetTest{2} = changeLabels2matchTrain(imdsTrainRandomized.Labels, imdsTestRandomized_Pro_pipe.Labels);
targetTest{3} = changeLabels2matchTrain(imdsTrainRandomized.Labels, imdsTestRandomized_Qian.Labels);