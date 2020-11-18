library(dplyr)
library(forcats)

# 1. exclude identification columns 
# 2. collapse low frequency levels in categorical variables 
# 3. create new column: title
# 4. join companion table
# source: encyclopedia-titanica.org
titanic <- readxl::read_excel("data/Titanic Maiden Voyage Passengers and Crew.xlsx", 
                               skip = 1, n_max = 2208) %>%
  janitor::clean_names() %>%
  mutate(survived = if_else(survived == "SAVED", 1, 0),
         age = case_when(
          grepl("m", age) ~ as.character(round(as.numeric(gsub("m", "", "10m"))/12, 1)), # so that "10m" is now "0.8"
          TRUE ~ age
  ) %>% as.numeric(),
         name = case_when(
          name == "BANFI,  Ugo" ~ "BANFI, Mr Ugo",
          name == "WALSH,  Kate" ~ "WALSH, Mrs Kate",
          TRUE ~ name),
        nationality = case_when(
          name == "FRASER, Mr J." ~ "English",
          name == "MCANDREWS, Mr William" ~ "English",
          name == "MELLOR, Mr Arthur" ~ "English",
          TRUE ~ nationality
        ),
        nationality = fct_lump_min(nationality, min = 50),
        class = case_when(
          grepl("Staff|Musician|Guarantee Group|Crew", class_dept)  ~ "crew",
          grepl("3rd Class Passenger", class_dept) ~ "3rd",
          grepl("2nd Class Passenger", class_dept) ~ "2nd",
          grepl("1st Class Passenger", class_dept) ~ "1st"
        ),
        title = gsub('(.*, )|(\\.?\\s.*)', '', name) %>% 
          fct_collapse("Mr" = "Mr",
                       "Miss" = "Miss",
                       "Mrs" = "Mrs",
                       other_level = "other")) %>% 
  select(-name, -born, -died, -ticket, -class_dept, -cabin, -fare, -occupation, -body, -boat) %>% 
  relocate(survived) 


# table of companion variables
rel <- readr::read_csv("data/query_result.csv") %>% 
  select(url = ETURL,
         age_approx = dob_approx,
         spouse = STAT_spouse, 
         sibling = STAT_sibling,
         parent = STAT_parent,
         children = STAT_children) %>% 
  mutate(across(3:6, ~ as.numeric(.) %>% coalesce(0)))

d <- titanic %>% 
  left_join(rel, by = "url") %>% 
  select(-url) 

# set approximate age to missing
d[d$age_approx != 0 & !is.na(d$age_approx), "age"] <- NA 
d$age_approx <- NULL
# use mode 0 to fill in 4 missing companion variables 
d[is.na(d$spouse), "spouse"] <- 0
d[is.na(d$sibling), "sibling"] <- 0
d[is.na(d$parent), "parent"] <- 0
d[is.na(d$children), "children"] <- 0

readr::write_csv(d, "data/titanic.csv")


