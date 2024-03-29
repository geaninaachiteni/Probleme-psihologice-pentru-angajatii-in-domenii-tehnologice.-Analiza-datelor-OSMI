#libraries
library(tidyverse)
library(dplyr)
#install.packages("janitor")
library(janitor)
#install.packages("rio")
library(rio)
#install_formats()
library(readxl)

getwd()

#importarea si citirea datelor OSMI
date2016 <- read.csv("mental-heath-in-tech-2016_20161114.csv", header = TRUE, sep = ",") %>%
  clean_names()
glimpse(date2016)

date2017 <- read.csv("OSMIMentalHealthinTechSurvey2017.csv", header = TRUE, sep = ",") %>%
  clean_names()
glimpse(date2017)

date2018 <- read.csv("OSMIMentalHealthinTechSurvey2018.csv", header = TRUE, sep = ",") %>%
  clean_names()
glimpse(date2018)

date2019 <- read.csv("OSMIMentalHealthinTechSurvey2019.csv", header = TRUE, sep = ",") %>%
  clean_names()
glimpse(date2019)

date2020 <- read.csv("OSMIMentalHealthinTechSurvey2020.csv", header = TRUE, sep = ",") %>%
  clean_names()
glimpse(date2020)

date2021 <- read.csv("OSMIMentalHealthinTechSurvey2021.csv", header = TRUE, sep = ",") %>%
  clean_names()
glimpse(date2021)


#eliminam textul nedorit (x_strong_, _strong, x_) din atribute
names(date2016) <- str_remove_all(names(date2016), "^x_strong_|_strong$|^x_")
names(date2017) <- str_remove_all(names(date2017), "^x_strong_|_strong$|^x_")
names(date2018) <- str_remove_all(names(date2018), "^x_strong_|_strong$|^x_")
names(date2019) <- str_remove_all(names(date2019), "^x_strong_|_strong$|^x_")
names(date2020) <- str_remove_all(names(date2020), "^x_strong_|_strong$|^x_")
names(date2021) <- str_remove_all(names(date2021), "^x_strong_|_strong$|^x_")


#names(date2021)
#glimpse(date2017)


#cream DataFrame-uri care contin atributele din chestionarele corespunzatoare fiecarui an, 
#inlocuind numele atributelor din care am eliminat anterior textul nedorit (x_strong_, _strong, x_)
attributes_2016 <- tibble(attribute=names(date2016))
attributes_2017 <- tibble(attribute=names(date2017))
attributes_2018 <- tibble(attribute=names(date2018))
attributes_2019 <- tibble(attribute=names(date2019))
attributes_2020 <- tibble(attribute=names(date2020))
attributes_2021 <- tibble(attribute=names(date2021))


#aflam atributele comune seturilor de date din fiecare an
common_attributes <- attributes_2016 %>%
  inner_join(attributes_2017) %>%
  inner_join(attributes_2018) %>%
  inner_join(attributes_2019) %>%
  inner_join(attributes_2020) %>%
  inner_join(attributes_2021)


#cream un DataFrame cu toate atributele
all_attributes <- bind_rows(
  attributes_2016 %>%
    mutate(year=2016), 
  attributes_2017 %>%
    mutate(year=2017),
  attributes_2018 %>%
    mutate(year=2018),
  attributes_2019 %>%
    mutate(year=2019),
  attributes_2020 %>%
    mutate(year=2020),
  attributes_2021 %>%
    mutate(year=2021)
)


#crearea fisierul Excel cu toate atributele 
rio::export(all_attributes, file="all_attributes.xlsx")



#aflam atributele care se regasesc in chestionarul din anul 2016 si nu se regasesc in cel din anul 2017
t2016 <- attributes_2016 %>%
  anti_join(attributes_2017)%>%
  arrange(attribute)

t2017 <- attributes_2017 %>%
  anti_join(attributes_2016)%>%
  arrange(attribute)



#aflam atributele comune anilor 2018 si 2019 
c_18_19 <- attributes_2018 %>%
  inner_join(attributes_2019)



#aflam ce atribute se regasescin setul de date din 2018 si nu se regasesc in cel din 2019
c18_n19 <- attributes_2018 %>%
  anti_join(attributes_2019)



#citirea fisierului Excel care contine atributele corespunzatoare
att_coresp <- read_excel("all_attributes_completat.xlsx")



#afisam denumirea initiala a atributelor si denumirea modificata a acestora
#2016
t2016 <- att_coresp %>% 
  filter(!is.na(attribute_OK)) %>%
  filter(year==2016)


new_names_2016 <- attributes_2016 %>%
  left_join(t2016) %>%
  mutate(new_attribute=coalesce(attribute_OK, attribute)) %>%
  pull(new_attribute)

names(date2016) <- new_names_2016


#2017
t2017 <- att_coresp %>% 
  filter(!is.na(attribute_OK)) %>%
  filter(year==2017)


new_names_2017 <- attributes_2017 %>%
  left_join(t2017) %>%
  mutate(new_attribute=coalesce(attribute_OK, attribute)) %>%
  pull(new_attribute)

names(date2017) <- new_names_2017


#2018
t2018 <- att_coresp %>% 
  filter(!is.na(attribute_OK)) %>%
  filter(year==2018)


new_names_2018 <- attributes_2018 %>%
  left_join(t2018) %>%
  mutate(new_attribute=coalesce(attribute_OK, attribute)) %>%
  pull(new_attribute)

names(date2018) <- new_names_2018


#2019
t2019 <- att_coresp %>% 
  filter(!is.na(attribute_OK)) %>%
  filter(year==2019)


new_names_2019 <- attributes_2019 %>%
  left_join(t2019) %>%
  mutate(new_attribute=coalesce(attribute_OK, attribute)) %>%
  pull(new_attribute)

names(date2019) <- new_names_2019

#2020
t2020 <- att_coresp %>% 
  filter(!is.na(attribute_OK)) %>%
  filter(year==2020)


new_names_2020 <- attributes_2020 %>%
  left_join(t2020) %>%
  mutate(new_attribute=coalesce(attribute_OK, attribute)) %>%
  pull(new_attribute)

names(date2020) <- new_names_2020


#2021
t2021 <- att_coresp %>% 
  filter(!is.na(attribute_OK)) %>%
  filter(year==2021)


new_names_2021 <- attributes_2021 %>%
  left_join(t2021) %>%
  mutate(new_attribute=coalesce(attribute_OK, attribute)) %>%
  pull(new_attribute)

names(date2021) <- new_names_2021


#modificam scala de raspuns la intrebarea:  
#how_willing_to_share_with_friends_family_that_you_have_mental_illnes
#deoarece pe parcursul anilor s-au utilizat scale diferite de raspuns

date2017$how_willing_to_share_with_friends_family_that_you_have_mental_illness

date2016$how_willing_to_share_with_friends_family_that_you_have_mental_illness

date2018$how_willing_to_share_with_friends_family_that_you_have_mental_illness

date2019$how_willing_to_share_with_friends_family_that_you_have_mental_illness

table(date2016$how_willing_to_share_with_friends_family_that_you_have_mental_illness)

date2016 <- date2016 %>%
  mutate(how_willing_to_share_with_friends_family_that_you_have_mental_illness=
           case_when(
             how_willing_to_share_with_friends_family_that_you_have_mental_illness=="Not applicable to me (I do not have a mental illness)" ~ NA_real_, 
             how_willing_to_share_with_friends_family_that_you_have_mental_illness=="Not open at all" ~ 2,
             how_willing_to_share_with_friends_family_that_you_have_mental_illness=="Somewhat not open" ~ 4,
             how_willing_to_share_with_friends_family_that_you_have_mental_illness=="Neutral" ~ 6,
             how_willing_to_share_with_friends_family_that_you_have_mental_illness=="Somewhat open" ~ 8,
             how_willing_to_share_with_friends_family_that_you_have_mental_illness=="Very open" ~ 10
           ))


table(date2016$how_willing_to_share_with_friends_family_that_you_have_mental_illness)


#Cream un DataFrame care include toate seturile de date 
df1 <- bind_rows(
  date2016 %>%
    mutate(year=2016),
  date2017 %>%
    mutate(year=2017),
  date2018 %>%
    mutate(year=2018),
  date2019 %>%
    mutate(year=2019),
  date2020 %>%
    mutate(year=2020),
  date2021 %>%
    mutate(year=2021)
)

names(df1)


#Intrebarea "how_many_employees_company" are raspunsuri de tip interval numeric
#in DataFrame intervalele 1-5 si 6-25 sunt interpretate ca fiind date calendaristice
df1 %>%
  group_by(how_many_employees_company) %>%
  tally()


df1 <- df1 %>%
  mutate(how_many_employees_company=case_when(
    how_many_employees_company == "01-May" ~ "1-5", 
    how_many_employees_company == "Jun-25" ~ "6-25",
    how_many_employees_company == "" ~ NA_character_,
    TRUE ~ how_many_employees_company
  )
           )


#atributul are_you_self_employed din seturile de date originale
#nu a fost inlocuit cu varianta simplificata a acestuia, desi comanda a fost rulata
temp <- df1 %>%
  select(self_employed, are_you_self_employed)

#verificam daca exista linii in care ambele atribute sunt completate
temp <- df1 %>%
  select(self_employed, are_you_self_employed) %>% 
  filter(!is.na(self_employed) & !is.na(are_you_self_employed))


temp2 <- df1 %>%
  select(self_employed, are_you_self_employed) %>% 
  mutate(test = coalesce(self_employed, are_you_self_employed))


df2 <- df1 %>%
  mutate(self_employed = coalesce(self_employed, are_you_self_employed)) %>%
  select(-are_you_self_employed)



#pentru a eficientiza urmatoarele etape ale procesarii ??i analizarii datelor am creat un "id" pentru fiecare respondent
df3 <- df2 %>%
  mutate(id = row_number())


#�nlocuim celulele care sunt goale cu valoari NA
df3[df3==""]<-NA


#names(df3)

#summary(df3)


#realizarea unui fi�??ier Excel pt. df
rio::export(df, file = "df.xlsx") 
