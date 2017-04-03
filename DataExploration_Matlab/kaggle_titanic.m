Train = readtable('train.csv','Format','%f%f%f%q%C%f%f%f%q%f%q%C');%loads train table%
Test = readtable('test.csv','Format','%f%f%q%C%f%f%f%q%f%q%C');%loads test table%

disp(Train(1:5,[2:3 5:8 10:11]));%displays-1:5rows,2,3,5,6,7,8,10,11:columns%

%statistics of female/male survived, from total female/male population%
disp(grpstats(Train(:,{'Survived','Sex'}), 'Sex'));

%gender model:%
gendermdl = grpstats(Train(:,{'Survived','Sex'}), {'Survived','Sex'});
disp(gendermdl);

%change fare to NaN if 0%
Train.Fare(Train.Fare == 0) = NaN;
Test.Fare(Test.Fare==0)= NaN;

vars = Train.Properties.VariableNames;%extract column names%

avgAge = nanmean(Train.Age);            %average age%
Train.Age(isnan(Train.Age)) = avgAge;   %replace NaN with the averageAge for Train%
Test.Age(isnan(Test.Age)) = avgAge;     %replace NaN with the averageAge for Train%

fare = grpstats(Train(:,{'Pclass','Fare'}),'Pclass');   % get class average

for i = 1:height(fare) % for each |Pclass| 1-to-3
    % apply the class average to missing values
    Train.Fare(Train.Pclass == i & isnan(Train.Fare)) = fare.mean_Fare(i);
    Test.Fare(Test.Pclass == i & isnan(Test.Fare)) = fare.mean_Fare(i);
end

%exploratory data analysis%

figure;

histogram(Train.Age(Train.Survived == 0))   % age histogram of non-survivers
hold on
histogram(Train.Age(Train.Survived == 1))   % age histogram of survivers
hold off
legend('Didn''t Survive', 'Survived')
title('The Titanic Passenger Age Distribution')

%Feature Engineering%

Train.AgeGroup = double(discretize(Train.Age, [0:10:20 65 80], ...
    'categorical',{'child','teen','adult','senior'}));

yfit = predict(trainedClassifier, Test{:,trainedClassifier.PredictorNames})