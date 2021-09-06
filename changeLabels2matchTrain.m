function targetTest = changeLabels2matchTrain(imdsTrain, imdsTest)

trainLabels = unique(imdsTrain);
testLabels  = unique(imdsTest);

[sharedvals,idx] = intersect(trainLabels, testLabels,'stable');

testLabelsgrpIdx = grp2idx(imdsTest);
testLabelsgrpIdx_unq = unique(testLabelsgrpIdx);

testLabels = changem(testLabelsgrpIdx, idx, testLabelsgrpIdx_unq);


targetTest = zeros(length(testLabels),length(trainLabels));
targetTest_onehot = full(ind2vec(testLabels'))';
targetTest(1:size(targetTest_onehot,1), 1:size(targetTest_onehot,2)) = targetTest_onehot;

end

