library(shiny)

nsim <- 1000
set.seed(12345)

shinyServer(
        function(input, output) {
                
                theo_mean_exp <- reactive({ 1 / input$lambda }) 
                theo_sd_exp <- reactive({ 1 / input$lambda })
                theo_sd_n_exp <- reactive({ 1 / (input$lambda * sqrt(input$nobs)) })
                
                theo_mean_unif <- reactive({ 0.5 * (input$lower + input$upper) }) 
                theo_sd_unif <- reactive({ (input$upper - input$lower) / sqrt(12) })
                theo_sd_n_unif <- reactive({ (input$upper - input$lower) / sqrt(12 * input$nobs) })
                
                theo_mean_norm <- reactive({ input$mean }) 
                theo_sd_norm <- reactive({ input$sd })
                theo_sd_n_norm <- reactive({ input$sd / sqrt(input$nobs) })
                
                output$ProbDist <- renderPlot({
                        
                        if (input$dist == 'exp'){
                                
                                x_dist <- seq(0, theo_mean_exp() + 4 * theo_sd_exp(), length = 2000)
                                y_dist <- dexp(x_dist, rate = input$lambda)
                                
                                main_text <- paste("Exponential Distribution with Lambda =", input$lambda)
                                
                                theo_mean <- theo_mean_exp()                                                                
                                theo_sd <- theo_sd_exp()
                                
                        } else if (input$dist == 'unif'){
                                
                                x_dist <- seq(input$lower - 0.2 * (input$upper - input$lower), 
                                              input$upper + 0.2 * (input$upper - input$lower), length = 2000)
                                y_dist <- dunif(x_dist, min = input$lower, max = input$upper)
                                
                                main_text <- paste("Uniform Distribution with Lower Limit =", input$lower, 
                                                   "and Upper Limit =", input$upper)
                                
                                theo_mean <- theo_mean_unif()                                                                
                                theo_sd <- theo_sd_unif()
                                
                        } else if (input$dist == 'norm'){
                                
                                x_dist <- seq(theo_mean_norm() - 4 * theo_sd_norm(), 
                                              theo_mean_norm() + 4 * theo_sd_norm(), length = 2000)
                                y_dist <- dnorm(x_dist, mean = theo_mean_norm(), sd = theo_sd_norm())
                                
                                main_text <- paste("Normal Distribution with Mean =", input$mean, 
                                                   "and Standard Deviation =", input$sd)
                                
                                theo_mean <- theo_mean_norm()                                                                
                                theo_sd <- theo_sd_norm()
                                
                        }
                        
                        
                        plot(x_dist, y_dist, type = "l", lwd = 2, col = "blue", xlab = "X", ylab = "P(X)", 
                             main = main_text)
                        
                        text(max(x_dist) * 0.9, max(y_dist), 
                             labels = paste("Mean =", as.character(round(theo_mean, 2))), 
                             pos = 1, col = "black")
                        text(max(x_dist) * 0.9, max(y_dist) * 0.9, 
                             labels = paste("Variance =", as.character(round(theo_sd ^ 2, 2))), 
                             pos = 1, col = "black")
                                
                        
                })
                
                output$Graph <- renderPlot({
                        mat <- matrix(nrow = nsim, ncol = input$nobs)
                        mns <- NULL
                        
                        if (input$dist == 'exp'){
                                clt_mean <- theo_mean_exp()
                                clt_sd <- theo_sd_n_exp()
                                                                
                                for (i in 1:nsim) {
                                        mat[i, ] <- rexp(input$nobs, input$lambda)
                                        mns <- c(mns, mean(mat[i, ]))
                                }
                        
                        } else if (input$dist == 'unif'){
                                clt_mean <- theo_mean_unif()
                                clt_sd <- theo_sd_n_unif()
                                
                                for (i in 1:nsim) {
                                        mat[i, ] <- runif(input$nobs, min = input$lower, max = input$upper)
                                        mns <- c(mns, mean(mat[i, ]))
                                }
                                
                        } else if (input$dist == 'norm'){
                                clt_mean <- theo_mean_norm()
                                clt_sd <- theo_sd_n_norm()
                                
                                for (i in 1:nsim) {
                                        mat[i, ] <- rnorm(input$nobs, mean = input$mean, sd = input$sd)
                                        mns <- c(mns, mean(mat[i, ]))
                                }
                                
                        }
                                                                        
                        XText <- paste("Average of", input$nobs, "Draws")
                        HistText <- paste("Probability Density of the Averages of", input$nobs, "Draws")
                        
                        SimHist <- hist(mns, freq = FALSE, xlab = XText, main = HistText, 
                                        ylim = c(0, dnorm(clt_mean, mean = clt_mean, sd = clt_sd) * 1.1))
                                                                        
                        points(mean(mns), dnorm(mean(mns), mean = clt_mean, sd = clt_sd), col = "red")
                        text(mean(mns), dnorm(mean(mns), mean = clt_mean, sd = clt_sd), 
                             labels = paste("Mean =", as.character(round(mean(mns), 2))), pos = 1, col = "red")
                        
                        text(mean(mns) + 2 * sd(mns), dnorm(mean(mns), mean = clt_mean, sd = clt_sd), 
                             labels = paste("Empirical Mean =", as.character(round(mean(mns), 2))), 
                             pos = 1, col = "black")
                
                        text(mean(mns) + 2 * sd(mns), dnorm(mean(mns), mean = clt_mean, sd = clt_sd) * 0.9, 
                             labels = paste("Empirical Variance =", as.character(round(var(mns), 2))), 
                             pos = 1, col = "black")
                                        
                        x <- seq(clt_mean - 4 * clt_sd, clt_mean + 4 * clt_sd, length = 2000)
                        curve(dnorm(x, mean = clt_mean, sd = clt_sd), lwd = 2, col = "blue", add = TRUE)         
                                                
                })

        }
)