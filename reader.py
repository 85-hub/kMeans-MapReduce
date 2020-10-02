from mapper import getCentroids
"""reader.py"""

__authors__ = "Hassan Elseoudy, Christoph Neumann"

#Check if distance of centroidsLast and centroidsCurrent is less than tolerance
def checkCentroidsDistance(centroidsLast, centroidsCurrent):
    tol = 1e-4
    C1a = abs(centroidsLast[0][0] - centroidsCurrent[0][0]) < tol
    C1b = abs(centroidsLast[0][1] - centroidsCurrent[0][1]) < tol
    C1c = abs(centroidsLast[0][2] - centroidsCurrent[0][2]) < tol
    C1d = abs(centroidsLast[0][3] - centroidsCurrent[0][3]) < tol
    C2a = abs(centroidsLast[1][0] - centroidsCurrent[1][0]) < tol
    C2b = abs(centroidsLast[1][1] - centroidsCurrent[1][1]) < tol
    C2c = abs(centroidsLast[1][2] - centroidsCurrent[1][2]) < tol
    C2d = abs(centroidsLast[1][3] - centroidsCurrent[1][3]) < tol
    C3a = abs(centroidsLast[2][0] - centroidsCurrent[2][0]) < tol
    C3b = abs(centroidsLast[2][1] - centroidsCurrent[2][1]) < tol
    C3c = abs(centroidsLast[2][2] - centroidsCurrent[2][2]) < tol
    C3d = abs(centroidsLast[2][3] - centroidsCurrent[2][3]) < tol


    if C1a and C1b and C1c and C1d and C2a and C2b and C2c and C2d and C3a and C3b and C3c and C3d:
        print(1) # So the runner script ends.
    else:
        print(0)

if __name__ == "__main__":
    centroidsLast = getCentroids('Dataset_Centroids/centroids-iter-last.csv')
    centroidsCurrent = getCentroids('Dataset_Centroids/centroids-iter-current.csv')
    
    checkCentroidsDistance(centroidsLast, centroidsCurrent)
