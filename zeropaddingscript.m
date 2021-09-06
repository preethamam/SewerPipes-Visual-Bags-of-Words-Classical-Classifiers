clc;
%clear
close all;

n_methods = 13;
newXTrain = [];
zeroPiddingSize = size(OutputStruct(1,1,3).XTrain, 1);
zeroPadding = zeros(zeroPiddingSize, 15000);

for c = 1:n_methods
	dict_x = OutputStruct(1,c,3).XTrain;
	dict_x(size(zeroPadding,1), size(zeroPadding,2)) = 0;
	newXTrain = cat(1,newXTrain,dict_x);
end


newXVal = [];
zeroPiddingSize = size(OutputStruct(1,1,3).XVal, 1);
zeroPadding = zeros(zeroPiddingSize, 15000);

for c = 1:n_methods
	dict_x = OutputStruct(1,c,3).XVal;
	dict_x(size(zeroPadding,1), size(zeroPadding,2)) = 0;
	newXVal = cat(1,newXVal,dict_x);
end


newXTest_LADWP = [];
zeroPiddingSize = size(OutputStruct(1,1,3).XTest_LADWP, 1);
zeroPadding = zeros(zeroPiddingSize, 15000);

for c = 1:n_methods
	dict_x = OutputStruct(1,c,3).XTest_LADWP;
	dict_x(size(zeroPadding,1), size(zeroPadding,2)) = 0;
	newXTest_LADWP = cat(1,newXTest_LADWP,dict_x);
end



newXTest_Pro_pipe = [];
zeroPiddingSize = size(OutputStruct(1,1,3).XTest_Pro_pipe, 1);
zeroPadding = zeros(zeroPiddingSize, 15000);

for c = 1:n_methods
	dict_x = OutputStruct(1,c,3).XTest_Pro_pipe;
	dict_x(size(zeroPadding,1), size(zeroPadding,2)) = 0;
	newXTest_Pro_pipe = cat(1,newXTest_Pro_pipe,dict_x);
end


newXTest_Qian = [];
zeroPiddingSize = size(OutputStruct(1,1,3).XTest_Qian, 1);
zeroPadding = zeros(zeroPiddingSize, 15000);

for c = 1:n_methods
	dict_x = OutputStruct(1,c,3).XTest_Qian;
	dict_x(size(zeroPadding,1), size(zeroPadding,2)) = 0;
	newXTest_Qian = cat(1,newXTest_Qian,dict_x);
end


newYTrain = [];
for c = 1:n_methods
	dict_x = OutputStruct(1,c,3).YTrain;
	newYTrain = cat(1,newYTrain,dict_x);
end

newYVal = [];
for c = 1:n_methods
	dict_x = OutputStruct(1,c,3).YVal;
	newYVal = cat(1,newYVal,dict_x);
end

newYTest_LADWP = [];
for c = 1:n_methods
	dict_x = OutputStruct(1,c,3).YTest_LADWP;
	newYTest_LADWP = cat(1,newYTest_LADWP,dict_x);
end

newYTest_Pro_pipe = [];
for c = 1:n_methods
	dict_x = OutputStruct(1,c,3).YTest_Pro_pipe;
	newYTest_Pro_pipe = cat(1,newYTest_Pro_pipe,dict_x);
end

newYTest_Qian = [];
for c = 1:n_methods
	dict_x = OutputStruct(1,c,3).YTest_Qian;
	newYTest_Qian = cat(1,newYTest_Qian,dict_x);
end



newYTrainStrings = [];
n_methods = 13;
index = 1;
for b = 1:n_methods
	n_samples = size(OutputStruct(1,b,3).XTrain,1);
	dict_size = size(OutputStruct(1,b,3).XTrain,2);
	for c = 1:n_samples
		newYTrainStrings{index} = ['class_' num2str(dict_size) '_' num2str(vec2ind(OutputStruct(1,b,3).YTrain(c,:).'), '%d')];
		index = index + 1;
	end
end

newYValStrings = [];
n_methods = 13;
index = 1;
for b = 1:n_methods
	n_samples = size(OutputStruct(1,b,3).XVal,1);
	dict_size = size(OutputStruct(1,b,3).XVal,2);
	for c = 1:n_samples
		newYValStrings{index} = ['class_' num2str(dict_size) '_' num2str(vec2ind(OutputStruct(1,b,3).YVal(c,:).'), '%d')];
		index = index + 1;
	end
end

newYTest_LADWPStrings = [];
n_methods = 13;
index = 1;
for b = 1:n_methods
	n_samples = size(OutputStruct(1,b,3).XTest_LADWP,1);
	dict_size = size(OutputStruct(1,b,3).XTest_LADWP,2);
	for c = 1:n_samples
		newYTest_LADWPStrings{index} = ['class_' num2str(dict_size) '_' num2str(vec2ind(OutputStruct(1,b,3).YTest_LADWP(c,:).'), '%d')];
		index = index + 1;
	end
end

newYTest_Pro_pipeStrings = [];
n_methods = 13;
index = 1;
for b = 1:n_methods
	n_samples = size(OutputStruct(1,b,3).XTest_Pro_pipe,1);
	dict_size = size(OutputStruct(1,b,3).XTest_Pro_pipe,2);
	for c = 1:n_samples
		newYTest_Pro_pipeStrings{index} = ['class_' num2str(dict_size) '_' num2str(vec2ind(OutputStruct(1,b,3).YTest_Pro_pipe(c,:).'), '%d')];
		index = index + 1;
	end
end

newYTest_Qian = [];
n_methods = 13;
index = 1;
for b = 1:n_methods
	n_samples = size(OutputStruct(1,b,3).XTest_Qian,1);
	dict_size = size(OutputStruct(1,b,3).XTest_Qian,2);
	for c = 1:n_samples
		newYTest_Qian{index} = ['class_' num2str(dict_size) '_' num2str(vec2ind(OutputStruct(1,b,3).YTest_Qian(c,:).'), '%d')];
		index = index + 1;
	end
end


% Comment

newYTrainStrings = [];
n_methods = 13;
index = 1;
for b = 1:n_methods
	n_samples = size(OutputStruct(1,b,3).XTrain,1);
	dict_size = size(OutputStruct(1,b,3).XTrain,2);
	for c = 1:n_samples
		newYTrainStrings{index} = ['class_' num2str(dict_size) '_' num2str(vec2ind(newYTrain(index,:).'), '%d')];
		index = index + 1;
	end
end




%% Shuffling
%% Path: /media/preethamam/Utilities-HDD/OneDrive/Team Work/Team SewerPipe/Programs/2020-12
inpstruct.nosamp = 'full';
featMat = newXTrain;
labelArray = vec2ind(newYTrain.')';

[ Feature_matrix, Labels, Target, indexMap ] = shuffleFeatMatLabel( featMat, labelArray, inpstruct);




