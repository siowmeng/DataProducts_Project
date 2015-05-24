library(shiny)
shinyUI(pageWithSidebar(
        headerPanel("Central Limit Theorem Illustration"),
        sidebarPanel(
                h3('Introduction'),
                p('The purpose of this Shiny app is to illustrate Central Limit Theorem 
                  with the use of simulation.'),
                p('First, select the type of probability distribution and the relevant 
                  attributes (e.g. lambda, mean). The probability density function will 
                  be shown as the top graph at the right panel.'),
                p('Then, use the slider to select the number of observations. The system 
                  will perform 1000 round of simulations. In each round, the system 
                  averages the selected number of observations. The averages are used to 
                  plot the histogram at the bottom of the right panel.'),
                p('At the bottom graph, you will be able to observe that the histogram is 
                  approximately normally distributed with:'),
                p('- Expected value is approximately equal to the mean of original distribution'),
                p('- Variance is approximately equal to the variance of original 
                  distribution divided by number of observations'),
                hr(),
                selectInput('dist', 'Probability Distribution:', 
                            c("Exponential" = "exp", "Uniform" = "unif", "Normal" = "norm")),
                conditionalPanel(
                        condition = "input.dist == 'exp'", 
                        numericInput('lambda', 'Lambda', 0.1, min = 0.1, max = 1, step = 0.1)
                ),
                conditionalPanel(
                        condition = "input.dist == 'unif'", 
                        numericInput('lower', 'Lower Limit', 0, min = -1, max = 0, step = 0.1),
                        numericInput('upper', 'Upper Limit', 1, min = 0.1, max = 1, step = 0.1)
                ),
                conditionalPanel(
                        condition = "input.dist == 'norm'", 
                        numericInput('mean', 'Mean', 0, min = -10, max = 10, step = 1),
                        numericInput('sd', 'Standard Deviation', 1, min = 0.2, max = 2, step = 0.2)
                ),
                
                ##sliderInput('nsim', 'Number of Simulations', value = 1000, min = 100, max = 2000, step = 100),
                sliderInput('nobs', 'Number of Observations per Simulation', value = 50, min = 2, max = 100, step = 2)
                ##submitButton('Submit')                
        ),
        mainPanel(
                plotOutput('ProbDist'),
                plotOutput('Graph')
        )
))

