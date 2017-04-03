#classification problem - the analysis of what sorts of people were likely to survive
#groups of people were more likely to survive than others, such as
#women, children, and the upper-class.

train = read.csv("C:\\Users\\Jishu\\Desktop\\titanic\\train.csv")
test = read.csv("C:\\Users\\Jishu\\Desktop\\titanic\\test.csv")
names(train)
# [1] "PassengerId" "Survived"    "Pclass"      "Name"        "Sex"         "Age"        
#[7] "SibSp"       "Parch"       "Ticket"      "Fare"        "Cabin"       "Embarked"
names(test)
# [1] "PassengerId" "Pclass"      "Name"        "Sex"         "Age"         "SibSp"      
#[7] "Parch"       "Ticket"      "Fare"        "Cabin"       "Embarked" 
# we need to predict Survived - it is the label
# the model we will generate from training data will predict survival test data
str(train)#structure of the data frame
#table - summary statistics
table(train$Survived)#returns -> how many survived "1",how many didnot "0"
prop.table(table(train$Survived)) # proportion calculation
test$Survived = rep(0,418)#adding a 0 vector column to test->survived assuming everyone is dead

#kaggle submission : PassengerId as well as our Survived predictions
submit = data.frame(PassengerId=test$PassengerId,Survived = test$Survived)
write.csv(submit, file="C:\\Users\\Jishu\\Desktop\\titanic\\submit_1.csv",row.names = FALSE)

                        #######Gender Class Model#######

summary(train$Sex) #statistics -sex
prop.table(table(train$Sex,train$Survived))
prop.table(table(train$Sex,train$Survived),1)#selects row wise
prop.table(table(train$Sex,train$Survived),2)#selects column wise

#updating submission
test$Survived = 0
#since most of the prop table most of the females survived from female population
test$Survived[test$Sex == 'female'] <- 1

submit = data.frame(PassengerId=test$PassengerId,Survived = test$Survived)
write.csv(submit, file="C:\\Users\\Jishu\\Desktop\\titanic\\submit_2.csv",row.names = FALSE)
 
    ##################Digging into Age Data#####################
summary(train$Age)

train$Child = 0 #new column child created
train$Child[train$Age<18]=1#child where age<18

#Survived~Child+Sex: subset->total survived
aggregate(Survived~Child+Sex,data = train,FUN=sum)

#Survived~Child+Sex: subset->total passengers travelling
aggregate(Survived~Child+Sex,data = train,FUN=length)

#ratio: survived passengers to total number of travelling passengers
aggregate(Survived~Child+Sex,data = train,FUN=function(x) {sum(x)/length(x)})

                  #######class and fare of passenger data#######

#binning fare data
#1.Less than $10,
#2.Between $10- $20,
#3.Between $20- $30.


train$Fare2 = '30+'
train$Fare2[train$Fare<10]='10-'
train$Fare2[train$Fare>10 & train$Fare<20]='10-20'
train$Fare2[train$Fare>20 & train$Fare<30]='20-30'

aggregate(Survived ~ Fare2 + Pclass + Sex, data=train, FUN=function(x) {sum(x)/length(x)})

aggregate(Survived ~ Fare2 + Pclass + Child + Sex, data=train, FUN=function(x) {sum(x)/length(x)})
summary(aggregate(Survived ~ Fare2 + Pclass + Child + Sex, data=train, FUN=function(x) {sum(x)/length(x)}))

#inference from the above analysis
test$Survived <- 0
test$Survived[test$Sex == 'female'] <- 1
test$Survived[test$Sex == 'female' & test$Pclass == 3 & test$Fare >= 20] <- 0


#kaggle submission : PassengerId as well as our Survived predictions
submit = data.frame(PassengerId=test$PassengerId,Survived = test$Survived)
write.csv(submit, file="C:\\Users\\Jishu\\Desktop\\titanic\\submit_3.csv",row.names = FALSE)


