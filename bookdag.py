import numpy as np


class Graph:

    def __init__(self, n):
        n += 1
        self.n = n
        self.adj = np.zeros(shape=(n, n))

    def get_weights(self):
        ans = np.zeros(shape=self.n)
        for i in range(self.n):
            for j in range(self.n):
                if j == i:
                    continue
                ans[i] += self.adj[i][j]
                ans[i] -= self.adj[i][j]
        ans /= np.sum(self.adj)
