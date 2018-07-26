/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: main.c
 *
 * MATLAB Coder version            : 3.3
 * C/C++ source code generated on  : 26-Jul-2018 11:14:04
 */

/*************************************************************************/
/* This automatically generated example C main file shows how to call    */
/* entry-point functions that MATLAB Coder generated. You must customize */
/* this file for your application. Do not modify this file directly.     */
/* Instead, make a copy of this file, modify it, and integrate it into   */
/* your development environment.                                         */
/*                                                                       */
/* This file initializes entry-point function arguments to a default     */
/* size and value before calling the entry-point functions. It does      */
/* not store or use any values returned from the entry-point functions.  */
/* If necessary, it does pre-allocate memory for returned values.        */
/* You can use this file as a starting point for a main function that    */
/* you can deploy in your application.                                   */
/*                                                                       */
/* After you copy the file, and before you deploy it, you must make the  */
/* following changes:                                                    */
/* * For variable-size function arguments, change the example sizes to   */
/* the sizes that your application requires.                             */
/* * Change the example values of function arguments to the values that  */
/* your application requires.                                            */
/* * If the entry-point functions return values, store these values or   */
/* otherwise use them as required by your application.                   */
/*                                                                       */
/*************************************************************************/
/* Include Files */
#include "rt_nonfinite.h"
#include "phi.h"
#include "main.h"
#include "phi_terminate.h"
#include "phi_emxAPI.h"
#include "phi_initialize.h"

/* Function Declarations */
static emxArray_real_T *argInit_3xUnbounded_real_T(void);
static double argInit_real_T(void);
static emxArray_real_T *c_argInit_UnboundedxUnbounded_r(void);
static void main_phi(void);

/* Function Definitions */

/*
 * Arguments    : void
 * Return Type  : emxArray_real_T *
 */
static emxArray_real_T *argInit_3xUnbounded_real_T(void)
{
  emxArray_real_T *result;
  static int iv1[2] = { 3, 2 };

  int idx0;
  int idx1;

  /* Set the size of the array.
     Change this size to the value that the application requires. */
  result = emxCreateND_real_T(2, iv1);

  /* Loop over the array to initialize each element. */
  for (idx0 = 0; idx0 < 3; idx0++) {
    for (idx1 = 0; idx1 < result->size[1U]; idx1++) {
      /* Set the value of the array element.
         Change this value to the value that the application requires. */
      result->data[idx0 + result->size[0] * idx1] = argInit_real_T();
    }
  }

  return result;
}

/*
 * Arguments    : void
 * Return Type  : double
 */
static double argInit_real_T(void)
{
  return 0.0;
}

/*
 * Arguments    : void
 * Return Type  : emxArray_real_T *
 */
static emxArray_real_T *c_argInit_UnboundedxUnbounded_r(void)
{
  emxArray_real_T *result;
  static int iv0[2] = { 2, 2 };

  int idx0;
  int idx1;

  /* Set the size of the array.
     Change this size to the value that the application requires. */
  result = emxCreateND_real_T(2, iv0);

  /* Loop over the array to initialize each element. */
  for (idx0 = 0; idx0 < result->size[0U]; idx0++) {
    for (idx1 = 0; idx1 < result->size[1U]; idx1++) {
      /* Set the value of the array element.
         Change this value to the value that the application requires. */
      result->data[idx0 + result->size[0] * idx1] = argInit_real_T();
    }
  }

  return result;
}

/*
 * Arguments    : void
 * Return Type  : void
 */
static void main_phi(void)
{
  emxArray_real_T *out;
  emxArray_real_T *s;
  emxArray_real_T *q;
  emxArray_real_T *qdot;
  emxArray_real_T *qddot;
  emxInitArray_real_T(&out, 2);

  /* Initialize function 'phi' input arguments. */
  /* Initialize function input argument 's'. */
  s = c_argInit_UnboundedxUnbounded_r();

  /* Initialize function input argument 'q'. */
  q = argInit_3xUnbounded_real_T();

  /* Initialize function input argument 'qdot'. */
  qdot = argInit_3xUnbounded_real_T();

  /* Initialize function input argument 'qddot'. */
  qddot = argInit_3xUnbounded_real_T();

  /* Call the entry-point 'phi'. */
  phi(s, q, qdot, qddot, argInit_real_T(), out);
  emxDestroyArray_real_T(out);
  emxDestroyArray_real_T(qddot);
  emxDestroyArray_real_T(qdot);
  emxDestroyArray_real_T(q);
  emxDestroyArray_real_T(s);
}

/*
 * Arguments    : int argc
 *                const char * const argv[]
 * Return Type  : int
 */
int main(int argc, const char * const argv[])
{
  (void)argc;
  (void)argv;

  /* Initialize the application.
     You do not need to do this more than one time. */
  phi_initialize();

  /* Invoke the entry-point functions.
     You can call entry-point functions multiple times. */
  main_phi();

  /* Terminate the application.
     You do not need to do this more than one time. */
  phi_terminate();
  return 0;
}

/*
 * File trailer for main.c
 *
 * [EOF]
 */
