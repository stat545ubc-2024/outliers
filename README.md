
# outliers

## Description

The outliers package provides a function, check_outliers(), to detect
and return outliers in numeric vectors. It supports two commonly used
methods: Z-score, which identifies data points that deviate
significantly from the mean, and the Interquartile Range (IQR), which
finds extreme values based on quartiles. The package offers flexibility
to customize thresholds for both methods, customize the quantile
algorithm type for the IQR method, and automatically handles missing
values.

## Installation

You can install the development version of outliers from
[GitHub](https://github.com/) with:

``` r
# Install the `devtools` package if you have not already
# install.packages("devtools")
library(devtools)
devtools::install_github("stat545ubc-2024/outliers", ref = "0.1.0")
```

## Examples

Here are some examples on how to use `check_outliers` in your work:

### Example 1 - Simple vector with outliers for both methods

``` r
library(outliers)

vec_1 <- c(1:20, 80000)

check_outliers(vec_1, "iqr")
#> [1] 80000
check_outliers(vec_1, "zscore")
#> [1] 80000
```

### Example 2 - Simple vector with no outliers

``` r
vec_2 <-c(1:5)

check_outliers(vec_2, "iqr")
#> No outliers found.
#> numeric(0)
check_outliers(vec_2, "zscore")
#> No outliers found.
#> numeric(0)
```

### Example 3 - Simple vector with outliers for one method, not the other

``` r
vec_3 <- c(0:10, -300, 500)

check_outliers(vec_3, "iqr")
#> [1] -300  500


# However, if that same vector is checked using the Z-score method...
check_outliers(vec_3, "zscore")
#> No outliers found.
#> numeric(0)
```

### Example 4 - Adjusting the threshold values

``` r
check_outliers(vec_3, "zscore", zscore_threshold = 1.5)
#> [1] -300  500
```

### Example 5 - Sample dataset

``` r
# install.packages("gapminder")
library(gapminder)

# Lets check for outliers within the population variable, 'pop' in the gapminder dataset

check_outliers(gapminder$pop, "iqr")
#>   [1]   46886859   51365468   56839289   62821884   70759295   80428306
#>   [7]   93074406  103764241  113704579  123315288  135656790  150448339
#>  [13]   56602560   65551171   76039390   88049823  100840058  114313951
#>  [19]  128962939  142938076  155975974  168546719  179914212  190010647
#>  [25]  556263527  637408000  665770000  754550000  862030000  943455000
#>  [31] 1000281000 1084035000 1164970000 1230075000 1280400000 1318683096
#>  [37]   47798986   55379852   64606759   45681811   52799062   59402198
#>  [43]   66134291   73312559   80264543   52088559   59861301   67946797
#>  [49]   76511887   47124000   49569000   51732000   53165019   54433565
#>  [55]   55630100   57374179   58623428   59925035   61083916   69145952
#>  [61]   71019069   73739117   76368453   78717088   78160773   78335266
#>  [67]   77718298   80597764   82011073   82350671   82400996  372000000
#>  [73]  409000000  454000000  506000000  567000000  634000000  708000000
#>  [79]  788000000  872000000  959000000 1034172547 1110396331   82052000
#>  [85]   90124000   99028000  109343000  121282000  136725000  153343000
#>  [91]  169276000  184816000  199278000  211060000  223547000   51889696
#>  [97]   60397973   63327987   66907826   69453570   47666000   49182000
#> [103]   50843200   52667100   54365564   56059245   56535636   56729703
#> [109]   56840847   57479469   57926999   58147733   86459025   91563009
#> [115]   95831757  100825279  107188273  113872473  118454974  122091325
#> [121]  124329269  125956499  127065841  127467972   46173816   47969150
#> [127]   49044790   47995559   55984294   63759976   71640904   80122492
#> [133]   88111030   95895146  102479927  108700891   45598081   47761980
#> [139]   47287752   53740085   62209173   73039376   81551520   93364244
#> [145]  106207839  119901274  135031164   46679944   53100671   60641899
#> [151]   69325921   78152686   91462088  105186881  120065004  135564834
#> [157]  153403524  169270617   46850962   53456774   60017788   67185766
#> [163]   75012988   82995088   91077287   48827160   52910342   56667095
#> [169]   60216677   62806748   65068149   47328791   52881328   58179144
#> [175]   63047647   67308928   71158647   50430000   51430000   53292000
#> [181]   54959000   56079000   56179000   56339704   56981620   57866349
#> [187]   58808266   59912431   60776238  157553000  171984000  186538000
#> [193]  198712000  209896000  220239000  232187835  242803533  256894189
#> [199]  272911760  287675526  301139947   50533506   56142181   62826491
#> [205]   69940728   76048996   80908147   85262356
check_outliers(gapminder$pop, "zscore")
#>  [1]  556263527  637408000  665770000  754550000  862030000  943455000
#>  [7] 1000281000 1084035000 1164970000 1230075000 1280400000 1318683096
#> [13]  372000000  409000000  454000000  506000000  567000000  634000000
#> [19]  708000000  788000000  872000000  959000000 1034172547 1110396331
```
