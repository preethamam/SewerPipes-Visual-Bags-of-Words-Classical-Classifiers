n_methods = 13;

for c = 1:n_methods
	XTrain = OutputStruct(1,c,3).XTrain;
    YTrain = OutputStruct(1,c,3).YTrain;
    XVal = OutputStruct(1,c,3).XVal;
    YVal = OutputStruct(1,c,3).YVal;
    XTest_LADWP = OutputStruct(1,c,3).XTest_LADWP;
    YTest_LADWP = OutputStruct(1,c,3).YTest_LADWP;
    XTest_Qian = OutputStruct(1,c,3).XTest_Qian;
    YTest_Qian = OutputStruct(1,c,3).YTest_Qian;
    XTest_Pro_pipe = OutputStruct(1,c,3).XTest_Pro_pipe;
    YTest_Pro_pipe = OutputStruct(1,c,3).YTest_Pro_pipe;
    filename = 'Data_size_' + string(size(XTrain, 2));
    save(filename, '-regexp', '^(?!(OutputStruct)$).');
end
