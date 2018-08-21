# cs284_finalProject

to do dynamic contact planner:
- accelerate cutsom integrator by vectorizing outer for loop
- achieve minimization of distance between obstacle and contact point


# important lessons (for fools)
- remember to remove start/stop constraint if it is in an infeasible position 
- remember to include constraints for all derivatives between decision variables
- things that may be impossible to fulfill: cost function, not constraint!
- when including dynamic effects in the Euler-Lagrange equation, always make sure to test with multiple time points (3+)

# open questions
- why does the curling happen so often
- in the current experimental set to be static, why are resulting moments not constant?

# important: most 'correct' version right now is the one in the experimental folder
