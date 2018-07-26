/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: phi.h
 *
 * MATLAB Coder version            : 3.3
 * C/C++ source code generated on  : 26-Jul-2018 11:14:04
 */

#ifndef PHI_H
#define PHI_H

/* Include Files */
#include <math.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>
#include "rt_nonfinite.h"
#include "rtwtypes.h"
#include "phi_types.h"

/* Function Declarations */
extern void phi(const emxArray_real_T *s, const emxArray_real_T *q, const
                emxArray_real_T *qdot, const emxArray_real_T *qddot, double L,
                emxArray_real_T *out);

#endif

/*
 * File trailer for phi.h
 *
 * [EOF]
 */
