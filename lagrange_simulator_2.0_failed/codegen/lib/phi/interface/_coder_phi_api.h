/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: _coder_phi_api.h
 *
 * MATLAB Coder version            : 3.3
 * C/C++ source code generated on  : 26-Jul-2018 11:14:04
 */

#ifndef _CODER_PHI_API_H
#define _CODER_PHI_API_H

/* Include Files */
#include "tmwtypes.h"
#include "mex.h"
#include "emlrt.h"
#include <stddef.h>
#include <stdlib.h>
#include "_coder_phi_api.h"

/* Type Definitions */
#ifndef struct_emxArray_real_T
#define struct_emxArray_real_T

struct emxArray_real_T
{
  real_T *data;
  int32_T *size;
  int32_T allocatedSize;
  int32_T numDimensions;
  boolean_T canFreeData;
};

#endif                                 /*struct_emxArray_real_T*/

#ifndef typedef_emxArray_real_T
#define typedef_emxArray_real_T

typedef struct emxArray_real_T emxArray_real_T;

#endif                                 /*typedef_emxArray_real_T*/

/* Variable Declarations */
extern emlrtCTX emlrtRootTLSGlobal;
extern emlrtContext emlrtContextGlobal;

/* Function Declarations */
extern void phi(emxArray_real_T *s, emxArray_real_T *q, emxArray_real_T *qdot,
                emxArray_real_T *qddot, real_T L, emxArray_real_T *out);
extern void phi_api(const mxArray * const prhs[5], const mxArray *plhs[1]);
extern void phi_atexit(void);
extern void phi_initialize(void);
extern void phi_terminate(void);
extern void phi_xil_terminate(void);

#endif

/*
 * File trailer for _coder_phi_api.h
 *
 * [EOF]
 */
