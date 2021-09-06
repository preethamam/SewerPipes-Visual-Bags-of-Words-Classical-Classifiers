%//%************************************************************************%
%//%*                              Ph.D                                    *%
%//%*                        Sewerpipe Package						       *%
%//%*                                                                      *%
%//%*             Name: Preetham Manjunatha             		           *%
%//%*             USC ID Number: 7356627445		                           *%
%//%*             USC Email: aghalaya@usc.edu                              *%
%//%*             Submission Date: --/--/2017                              *%
%//%************************************************************************%
%//%*             Viterbi School of Engineering,                           *%
%//%*             Sonny Astani Dept. of Civil Engineering,                 *%
%//%*             University of Southern california,                       *%
%//%*             Los Angeles, California.                                 *%
%//%************************************************************************%

%% Start parameters
%//%************************************************************************%
% clear; 
clearvars -except OutputStruct
close all; clc;
tic;
clcwaitbarz = findall(0,'type','figure','tag','TMWWaitbar');
delete(clcwaitbarz);

%% Inputs
% General
matFileLocation = '/media/preethamam/Utilities-SSD/Xtreme_Programming/Preetham/MATLAB/Sewerpipe';
largeMatFilesNum = 4;
largeMatFilesName = 'ZZZ_ds_combo_Output_Detector_';
inpstruct_shuffle.nosamp = 'full';
inputStruct.concatenateVocSixe_zeropad = 1;
datasetnum = 1;
fr_type = 'LDA'; %'PCA'
numFeatures  = 50;
gridSize = 1;     % [4 8 16 32 64]
    
% Neural network
% Number of hidden layers [maximum 3]
hidden_layers = 'null';

% Hidden layer size
% hiddenLayerSize_Vec = 5:5:1000;     % 1 HL
hiddenLayerSize_Vec   = 30:90:1000;   % 2 HL
% hiddenLayerSize_Vec = 20:50:500;    % 3 HL

% Window view / plotting options [on | off]
inputStruct.plotter      = 'off';
inputStruct.viewfinalnet = 'off';

%% Create hidden layers (>1) neuron units combinations
%//%************************************************************************%
switch hidden_layers    
    case 1
        inputStruct.pairs = hiddenLayerSize_Vec(:);

    case 2
        [p,q] = meshgrid(hiddenLayerSize_Vec, hiddenLayerSize_Vec);
        inputStruct.pairs = [p(:) q(:)];

    case 3
        [p,q,r] = meshgrid(hiddenLayerSize_Vec, hiddenLayerSize_Vec, hiddenLayerSize_Vec);
        inputStruct.pairs = [p(:) q(:) r(:)];     
    otherwise
        inputStruct.pairs = [];
end
   
    
%% Get the testing labels 
% Load the labels 
load ZZZ_ds_combo_1.mat

% Change target labels to match the training labels 
targetTest{1} = changeLabels2matchTrain(imdsTrainRandomized.Labels, imdsTestRandomized_LADWP.Labels);
targetTest{2} = changeLabels2matchTrain(imdsTrainRandomized.Labels, imdsTestRandomized_Pro_pipe.Labels);
targetTest{3} = changeLabels2matchTrain(imdsTrainRandomized.Labels, imdsTestRandomized_Qian.Labels);

%% Processing
algoCNT = 1;

% Loop thru the MAT files
for itrMatFile = 1:largeMatFilesNum
    
    % Load the large MAT file
    inputStruct.matFileName = [largeMatFilesName num2str(itrMatFile) '.mat'];
    load (fullfile(matFileLocation, inputStruct.matFileName));
        
    % Loop thru algorithms
    for methodAlgo = 1:size(OutputStruct,3)
        
        for grid = 1:length(gridSize)
            
            % Grid step
            gridStep = gridSize(grid); 
        
            if (inputStruct.concatenateVocSixe_zeropad == 1)

                % Print current iteration
                fprintf('\n');
                fprintf('Dataset: %d | AlgoType: %s (Alg itr.: %d) | GridSize: %d (Grid itr.: %d) \n', ...
                    datasetnum, string(OutputStruct(datasetnum,1,algoCNT,gridStep).AlgorithmMethod), algoCNT, gridStep, grid);


                %%%%%%%%%%%%%%%%%%%%%%%%% Dummy dataset to test
                %{
                load iris_dataset.mat

                irisInputs = irisInputs';
                irisTargets = irisTargets';

                labelArray = vec2ind(irisTargets.')';
                inpstruct_shuffle.nosamp = 'full';

                [irisInputs, Labels, irisTargets, indexMap] = shuffleFeatMatLabel(irisInputs, labelArray, inpstruct_shuffle);

                zpOutput.Xtrain = irisInputs(1:100,:);
                zpOutput.Xval = irisInputs(101:120,:);
                zpOutput.Xtest = irisInputs(121:150,:);

                zpOutput.YtrainTargets = irisTargets(1:100,:); 
                zpOutput.YvalTargets = irisTargets(101:120,:); 
                zpOutput.YtestTargets = irisTargets(121:150,:);
                %}
                %%%%%%%%%%%%%%%%%%%%%%%%%

                % Get sizes
                inputStruct.maxVocSize = size(OutputStruct(1,end,1,gridStep).XTrain,2);
                inputStruct.iVocSize = size(OutputStruct,2);
                inputStruct.totalTestDatasets = size(targetTest,2);
                inputStruct.szYTest_LADWP = size(targetTest{1},1);
                inputStruct.szTest_Pro_pipe = size(targetTest{2},1);
                inputStruct.szYTest_Qian = size(targetTest{3},1);
                
                % Zero pad the feature matrices and targets of train, tesr and vals.
                zpOutput = zeroPadder(inpstruct_shuffle, OutputStruct, inputStruct.maxVocSize, methodAlgo, datasetnum, targetTest);

                % Free up the memory
                clear OutputStruct

                % This script assumes these variables are defined:
                % ************************************************************************%
                %   Feature_matrix - input data
                %   Labels - target data

                % Change of variables
                % [ 1 2 3 4 5 6 6 7 7 8 8 8 ...... 12]
                % [ 1 2 3 4 5 6 6 7 7 8 8 8 ...... 12]
                % [ 1 2 3 4 5 6 6 7 7 8 8 8 ...... 12]
                %  . . . . . . . . . . . . . . . . . .
                % [ 1 2 3 4 5 6 6 7 7 8 8 8 ...... 12]
                % [ 1 2 3 4 5 6 6 7 7 8 8 8 ...... 12]
                % rows x columns [n x m]
                % n - samples; m - features (requires transpose). Similarly, to
                % labels/targets
                % If not the above format, then no need to transpose
                %
                % Feature matrix (transposed) and % Labels/targets (transposed)
                % ************************************************************************%
                % Prepare X and Y feature matrices and labels
                % Create/concatenate the feature and

                % Get sizes of the variables
                inputStruct.maxVocSize = size(zpOutput.Xtrain,2);
                inputStruct.szTrain = size(zpOutput.Xtrain,1); 
                inputStruct.szVal = size(zpOutput.Xval,1); 
                inputStruct.szTest = size(zpOutput.Xtest,1);
                inputStruct.szY = size(zpOutput.YtrainTargets,2);
                

                % Feature matrices and Targets
                X = double([zpOutput.Xtrain; zpOutput.Xval; zpOutput.Xtest]');
                inputStruct.t = [zpOutput.YtrainTargets; zpOutput.YvalTargets; zpOutput.YtestTargets]';
                inputStruct.x = sparse(X);

                % Free up the memory
                clear zpOutput X

                % Feature reduction
                % [mapped_data, mapping] = compute_mapping(x, fr_type, 100);
                % [coeff,x,latent,tsquared] = pca(x,'NumComponents', 350);

                % Neural network code
                outputRecordStruct(datasetnum,algoCNT,1).annOutput = annProcessor(inputStruct);

            else
                    for vocSize = 1:size(OutputStruct,2)

                        % Print current iteration
                        fprintf('\n');
                        fprintf('Dataset: %d | VocSize: %d (Voc itr.: %d) | AlgoType: %s (Alg itr.: %d) | GridSize: %d (Grid itr.: %d) \n', ...
                        datasetnum, VocabSize(vocSize), vocSize, string(OutputStruct(datasetnum,vocSize,algoCNT,gridStep).AlgorithmMethod), ...
                        algoCNT, gridStep, grid);

                        %%%%%%%%%%%%%%%%%%%%%%%%% Dummy dataset to test
                        %{
                        load iris_dataset.mat

                        irisInputs = irisInputs';
                        irisTargets = irisTargets';

                        labelArray = vec2ind(irisTargets.')';
                        inpstruct_shuffle.nosamp = 'full';

                        [irisInputs, Labels, irisTargets, indexMap] = shuffleFeatMatLabel(irisInputs, labelArray, inpstruct_shuffle);

                        Output.Xtrain = irisInputs(1:100,:);
                        Output.Xval = irisInputs(101:120,:);
                        Output.Xtest = irisInputs(121:150,:);

                        Output.YtrainTargets = irisTargets(1:100,:); 
                        Output.YvalTargets = irisTargets(101:120,:); 
                        Output.YtestTargets = irisTargets(121:150,:);
                        %}
                        %%%%%%%%%%%%%%%%%%%%%%%%%

                        % Get train, val and test data
                        Output.Xtrain       = OutputStruct(datasetnum,vocSize,methodAlgo,gridStep).XTrain; 
                        Output.Xval         = OutputStruct(datasetnum,vocSize,methodAlgo,gridStep).XVal; 
                        Output.Xtest        = [OutputStruct(datasetnum,vocSize,methodAlgo,gridStep).XTest_LADWP; ...
                                              OutputStruct(datasetnum,vocSize,methodAlgo,gridStep).XTest_Pro_pipe; ...
                                              OutputStruct(datasetnum,vocSize,methodAlgo,gridStep).XTest_Qian];

                        Output.YtrainTargets       = OutputStruct(datasetnum,vocSize,methodAlgo,gridStep).YTrain;
                        Output.YvalTargets         = OutputStruct(datasetnum,vocSize,methodAlgo,gridStep).YVal; 
                        Output.YtestTargets        = [targetTest{1}; targetTest{2}; targetTest{3}];

                        % This script assumes these variables are defined:
                        % ************************************************************************%
                        %   Feature_matrix - input data
                        %   Labels - target data

                        % Change of variables
                        % [ 1 2 3 4 5 6 6 7 7 8 8 8 ...... 12]
                        % [ 1 2 3 4 5 6 6 7 7 8 8 8 ...... 12]
                        % [ 1 2 3 4 5 6 6 7 7 8 8 8 ...... 12]
                        %  . . . . . . . . . . . . . . . . . .
                        % [ 1 2 3 4 5 6 6 7 7 8 8 8 ...... 12]
                        % [ 1 2 3 4 5 6 6 7 7 8 8 8 ...... 12]
                        % rows x columns [n x m]
                        % n - samples; m - features (requires transpose). Similarly, to
                        % labels/targets
                        % If not the above format, then no need to transpose
                        %
                        % Feature matrix (transposed) and % Labels/targets (transposed)
                        % ************************************************************************%
                        % Prepare X and Y feature matrices and labels

                        % Get sizes of the variables
                        inputStruct.maxVocSize = size(Output.Xtrain, 2);
                        inputStruct.szTrain = size(Output.Xtrain, 1);
                        inputStruct.szVal = size(Output.Xval,1); 
                        inputStruct.szTest = size(Output.YtrainTargets,2);
                        inputStruct.szY = size(Output.YtrainTargets,2);

                        % Feature matrices and Targets
                        X = double([Output.Xtrain; Output.Xval; Output.Xtest]');
                        inputStruct.t = [Output.YtrainTargets; Output.YvalTargets; Output.YtestTargets]';
                        inputStruct.x = sparse(X);

                        % Free up the memory
                        clear Output X

                        % Neural network code
                        outputRecordStruct(datasetnum,algoCNT,vocSize).annOutput = annProcessor(inputStruct);

                    end 
            end
        end
        algoCNT = algoCNT + 1;
    end
    
    % Save the Outputs
    if (concatenateVocSixe_zeropad == 1)
        save ([largeMatFilesName 'ANN_ClassifierResults_Zeropadded_' num2str(itrMatFile) '.mat'], 'outputRecordStruct', '-v7.3')
    else
        save ([largeMatFilesName 'ANN_ClassifierResults_Individual_' num2str(itrMatFile) '.mat'], 'outputRecordStruct', '-v7.3')
    end
    
    % Clear the current parallel pool
    delete(gcp('nocreate'));
end


%% Post-proceesing the results of the network
%//%************************************************************************%



%% End parameters
% Close figures, waitbars and all
clcwaitbarz = findall(0,'type','figure','tag','TMWWaitbar');
delete(clcwaitbarz);

% Close nntraintool window
% nntraintool('close');

% Runtime
Runtime = toc;
