clc;
%clear
close all;

n_methods = 13;
newXTrain = [];
zeroPiddingSize = size(OutputStruct(1,1,3).XTrain, 1);
zeroPadding = zeros(zeroPiddingSize, 15000);

% Load the labels 
% load ZZZ_ds_combo_1.mat

newYTrain = [];
for c = 1:n_methods
	dict_x = OutputStruct(1,c,3).YTest_LADWP;
    targetTest = changeLabels2matchTrain(imdsTrainRandomized.Labels, dict_x);
	newYTrain = cat(1,newYTrain,dict_x);
end