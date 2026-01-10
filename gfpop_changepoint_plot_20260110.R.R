# Load required packages
library(gfpop)
library(ggplot2)

# Define edges
e1 <- Edge("normal", "normal", "null", penalty = 0, decay = 1)
e2 <- Edge("normal", "noChange", "std", penalty = 1, decay = 1)
e3 <- Edge("noChange", "normal", "null", penalty = 0, decay = 1)

# Create graph
mygraph <- graph(e1, e2, e3)

# Sample data
data <- c(1,2,2,3,5,6,5,7)

# Run gfpop
res <- gfpop(data, mygraph, type = "mean")

# Prepare data for plotting
df <- data.frame(
  x = 1:length(data),
  y = data
)

# Create changepoint segments
segments <- data.frame(
  start = c(1, res$changepoints[-length(res$changepoints)] + 1),
  end = res$changepoints,
  mean = res$parameters
)

# Plot
p <- ggplot(df, aes(x = x, y = y)) +
  geom_line(color = "blue") +
  geom_point(color = "red") +
  geom_segment(data = segments, aes(x = start, xend = end, y = mean, yend = mean), color = "green", size = 1.2) +
  theme_minimal() +
  labs(title = "Changepoints detected by gfpop", x = "Index", y = "Value")

# Save plot to desktop
desktop_path <- file.path(Sys.getenv("HOME"), "Desktop", "gfpop_plot.png")
ggsave(desktop_path, plot = p, width = 8, height = 4)