library(dplyr)
library(tidyr)

## one can simply enter data directly to the console
weight <- c(1,5,3,2,6)
length <- c(10,17,14,12,18)
plot(length,weight)

## or be more clever
dat <- data.frame(id=numeric(0), species=character(0),
                  length=numeric(0),age=numeric(0),
                  lat = numeric(0),lon=numeric(0))
dat <- edit(dat)

## read in the minke data properly
minke <-
  read.table(file = 'data/minke.csv', ## path to the file
             header = TRUE,       ## are column names
             ## at the top
             dec = '.',           ## decimal sign
             sep = ',',           ## column separator symbol
             skip = 0,            ## num lines at top to skip
             stringsAsFactors = FALSE,
             comment.char = '#')  ## indicating comments

## or you can use
minke <- read.csv('data/minke.csv')

## simple sanity checks
head(minke)
tail(minke)
dim(minke)
names(minke)
summary(minke)
str(minke)

## one can write the data to file
write.table(minke,
            file = 'minke-class.csv', ## file name
            col.names = TRUE,    ## write header
            row.names = FALSE,   ## write row names
            quote = FALSE,       ## characters qouted?
            sep = ',',
            dec = '.')
## or simply
write.csv(minke,file='minke.csv')

## location of files
minke <-
  read.csv('http://www.hafro.is/~bthe/minke.csv')

catatage <-
  read.csv('http://data.hafro.is/assmt/2015/cod/catage.csv')

## excel files
library(readxl)

minke.xls <- read_excel("minke.xlsx")

## write excel files
library(openxlsx)

write.xlsx(minke,file='minke.xlsx')

fish <- read.csv2('lec1/fish.csv')

write.xlsx(list("minke"=minke,'fish'=fish),file='minkeandfish.xlsx')

## list sheets
excel_sheets('minkeandfish.xlsx')

## read in only the fish data
fish.xls <- read_excel('minkeandfish.xlsx',sheet = 'fish')

## database connectivity
library(ora)
## query the database
hvalir <- sql('select * from hvalir.hvalir_v')

cod <- sql('select * from fiskar.kvarnir where tegund = 1')

## describe the table (analogous to str in R)
desc('hvalir.hvalir_v')

## list all tables or view owned by 'hvalir'
tables('hvalir')
views('hvalir')

## see all the data in fjolst and Logbooks
data('fjolst')
data('Logbooks')

###################################

## One can create a subset of the data using the \texttt{filter} command:
## load dplyr
library(dplyr)
## create a dataset with only females
minke.females <-
  filter(minke,sex=='Female')


## or non-pregnant
minke.nonpregnant <-
  filter(minke,sex=='Female', maturity != 'pregnant')

## select id, age, length and sex
minke.redux <-
  select(minke,whale.id,age,length,sex)

## select all column except stomach volume and weight
minke.noStom <-
  select(minke,-contains('stomach'))

## select id and all column between length and sex
minke.min <-
  select(minke,c(whale.id,length:sex))

## arrange by length (ascending)
minke.lasc <-
  arrange(minke,length)

## arrange by length (descending)
minke.ldesc <-
  arrange(minke,desc(length))

## arrange by age and then length (ascending)
minke.alasc <-
  arrange(minke,age,length)

## add new column old style
minke$approx.weight <- 3.85*1e-06*minke$length^3.163

## add new column using mutate
minke <-
  mutate(minke,
         approx.weight = 3.85*1e-06*length^3.163)

## not really useful until you add more than one
minke <-
  mutate(minke,
         approx.weight = 3.85*1e-06*length^3.163,
         adj.weight = ifelse(is.na(weight),approx.weight,
                         weight))
## create summaries
summarise(minke,num.obs = n())

## you can have as many as you like
summarise(minke,
          num.obs = n(),
          num.fem = sum(sex == 'Female'),
          num.large = sum(length > 650))

## But not particularly interesting until one can group the data
minke.NS <- group_by(minke,area)
summarise(minke.NS,
          num.obs = n(),
          num.fem = sum(sex == 'Female'),
          num.large = sum(length > 650))


## this is the same as splitting things up
minke.N <- filter(minke,area=='North')
summarise(minke.N,
          num.obs = n(),
          num.fem = sum(sex == 'Female'),
          num.large = sum(length > 650))


minke.S <- filter(minke,area=='South')
summarise(minke.S,
          num.obs = n(),
          num.fem = sum(sex == 'Female'),
          num.large = sum(length > 650))


## reshape data
## read in data in a wide format and convert to long format
catatage <-
  read.csv('http://data.hafro.is/assmt/2015/cod/catage.csv')

head(catatage)

catlong <-
  gather(catatage,age,number,-Year)

head(catlong)

## long to wide
minke.y.a <- group_by(minke,year,area)
num.minke.y.a <- summarise(minke.y.a,num=n())

spread(num.minke.y.a,year,num)


## separate
minke.by.day <-
  separate(minke,date.caught,c('yr','m','d'),sep='-')

## combine
minke.m.s <-
  unite(minke,mat.sex,c(sex,maturity),sep='-')


## chaining operations together
summarise(
  group_by(
    filter(minke,!is.na(weight)),
    sex),
  num.whale=n(),
  m.weight = mean(weight)
)


## using the %>% operator
minke %>%
  filter(!is.na(weight)) %>%
  group_by(sex) %>%
  summarise(num.whale = n(),
            m.weight = mean(weight))

## lets do more
minke %>%
  filter(area == 'North') %>%
  group_by(maturity) %>%
  summarise(n=n(),
            num.na = sum(is.na(age)),
            m.age = mean(age,na.rm=TRUE),
            sd.age = sd(age,na.rm=TRUE)) %>%
  mutate(prop = n/sum(n)) %>%
  arrange(prop)

## play with ungroup
minke %>%
  group_by(maturity) %>%
  mutate(lnorm.in = length/mean(length)) %>%
  ungroup() %>%
  mutate(lnorm.out = length/mean(length)) %>%
  select(whale.id,maturity,lnorm.in,lnorm.out)


## class excercise

## num caught by year

minke %>%
  group_by(year) %>%
  summarise(num.caught = n())

## num which are females

minke %>%
  group_by(year) %>%
  summarise(num.caught = n(),
            num.fem = sum(sex=='Female'))

## mean age and sd by maturity

minke %>%
  group_by(maturity) %>%
  summarise(ml = mean(length),
            sdl = sd(length),
            ma = mean(age),
            sda = sd(age))

