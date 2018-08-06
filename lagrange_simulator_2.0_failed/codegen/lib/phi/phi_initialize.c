/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: phi_initialize.c
 *
 * MATLAB Coder version            : 3.3
 * C/C++ source code generated on  : 26-Jul-2018 11:14:04
 */

/* Include Files */
#include "rt_nonfinite.h"
#include "phi.h"
#include "phi_initialize.h"

/* Function Definitions */

/*
 * Arguments    : void
 * Return Type  : void
 */
void phi_initialize(void)
{
  rt_InitInfAndNaN(8U);
}

/*
 * File trailer for phi_initialize.c
 *
 * [EOF]
 */
