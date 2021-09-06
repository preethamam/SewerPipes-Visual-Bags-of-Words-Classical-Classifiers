function output = zeroPadder(inpstruct, OutputStruct, maxVocSize, methodAlgo, ds, targetTest)

% Initialize the empty arrays
catXTrain = [];
catXVal = [];
catXTest_LADWP = [];
catXTest_Pro_pipe = [];
catXTest_Qian = [];

% Zero pads
% Train
zpSize_XTrain = size(OutputStruct(ds,1,1).XTrain, 1);
zp_XTrain = zeros(zpSize_XTrain, maxVocSize);

% Validation
zpSize_xVal = size(OutputStruct(ds,1,1).XVal, 1);
zp_xVal = zeros(zpSize_xVal, maxVocSize);

% Test
zpSize_XTest_LADWP = size(OutputStruct(ds,1,1).XTest_LADWP, 1);
zp_XTest_LADWP = zeros(zpSize_XTest_LADWP, maxVocSize);

zpSize_XTest_Pro_pipe = size(OutputStruct(ds,1,1).XTest_Pro_pipe, 1);
zp_XTest_Pro_pipe = zeros(zpSize_XTest_Pro_pipe, maxVocSize);

zpSize_XTest_Qian = size(OutputStruct(ds,1,1).XTest_Qian, 1);
zp_XTest_Qian = zeros(zpSize_XTest_Qian, maxVocSize);

for vocSize = 1:size(OutputStruct,2)

    % Concatenating the feature matrices
    % Training
    dict_xtrain = OutputStruct(ds, vocSize, methodAlgo).XTrain;
    dict_xtrain(size(zp_XTrain,1), size(zp_XTrain,2)) = 0;
    catXTrain = cat(1,catXTrain,dict_xtrain);

    % Validation
    dict_xval = OutputStruct(ds,vocSize, methodAlgo).XVal;
    dict_xval(size(zp_xVal,1), size(zp_xVal,2)) = 0;
    catXVal = cat(1,catXVal,dict_xval);

    % Testing
    dict_XTest_LADWP = OutputStruct(ds,vocSize, methodAlgo).XTest_LADWP;
    dict_XTest_LADWP(size(zp_XTest_LADWP,1), size(zp_XTest_LADWP,2)) = 0;
    catXTest_LADWP = cat(1,catXTest_LADWP,dict_XTest_LADWP);

    dict_XTest_Pro_pipe = OutputStruct(ds,vocSize, methodAlgo).XTest_Pro_pipe;
    dict_XTest_Pro_pipe(size(zp_XTest_Pro_pipe,1), size(zp_XTest_Pro_pipe,2)) = 0;
    catXTest_Pro_pipe = cat(1,catXTest_Pro_pipe,dict_XTest_Pro_pipe);

    dict_XTest_Qian = OutputStruct(ds,vocSize, methodAlgo).XTest_Qian;
    dict_XTest_Qian(size(zp_XTest_Qian,1), size(zp_XTest_Qian,2)) = 0;
    catXTest_Qian = cat(1,catXTest_Qian,dict_XTest_Qian);
end

% Concatenating the labels and shuffling
iVocSize = size(OutputStruct,2);

% Training
dict_ytrain = OutputStruct(ds,1,1).YTrain;
catYTrain = repmat(dict_ytrain, iVocSize, 1);

% Validation
dict_yval = OutputStruct(ds,1,1).YVal;
catYVal = repmat(dict_yval, iVocSize, 1);

% Testing
catYTest_LADWP = repmat(targetTest{1}, iVocSize, 1);
catYTest_Pro_pipe = repmat(targetTest{2}, iVocSize, 1);
catYTest_Qian = repmat(targetTest{3}, iVocSize, 1);

% Shuffling feature matrices and labels
labXtrain = vec2ind(catYTrain.')';
labXval = vec2ind(catYVal.')';

[shuffXtrain, shuffYtrain, shuff_xtrainTargets, shuffxtrainindexMap] = ...
    shuffleFeatMatLabel(catXTrain, labXtrain, inpstruct);

[shuffXval, shuffYval, shuff_xvalTargets, shuffxvalindexMap] = ...
    shuffleFeatMatLabel(catXVal, labXval, inpstruct);

% Final output structure
output.Xtrain = shuffXtrain;
output.Ytrain = shuffYtrain;
output.YtrainTargets = shuff_xtrainTargets;

output.Xval = shuffXval;
output.Yval = shuffYval;
output.YvalTargets = shuff_xvalTargets;

output.Xtest = [catXTest_LADWP; catXTest_Pro_pipe; catXTest_Qian];
output.Ytest = vec2ind([catYTest_LADWP; catYTest_Pro_pipe; catYTest_Qian].')';
output.YtestTargets = [catYTest_LADWP; catYTest_Pro_pipe; catYTest_Qian];

end

