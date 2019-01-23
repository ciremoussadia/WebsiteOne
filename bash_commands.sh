#!/bin/bash
## CREATE PLAN
curl -v -X POST https://api.sandbox.paypal.com/v1/payments/billing-plans/ \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer Access-Token" \
  -d '{
    "name": "Premium",
    "description": "Find great developer jobs? Get help on the job search process?",
    "type": "fixed",
    "payment_definitions": [
  {
    "name": "Regular payment definition",
    "type": "REGULAR",
    "frequency": "MONTH",
    "frequency_interval": "1",
    "amount":
    {
      "value": "10",
      "currency": "GBP"
    },
    "cycles": "12",
    "charge_models": [
    {
      "type": "SHIPPING",
      "amount":
      {
        "value": "0",
        "currency": "GBP"
      }
    },
    {
      "type": "TAX",
      "amount":
      {
        "value": "0",
        "currency": "GBP"
      }
    }]
  },
  {
    "name": "Trial payment definition",
    "type": "trial",
    "frequency": "week",
    "frequency_interval": "1",
    "amount":
    {
      "value": "0",
      "currency": "GBP"
    },
    "cycles": "1",
    "charge_models": [
    {
      "type": "SHIPPING",
      "amount":
      {
        "value": "0",
        "currency": "GBP"
      }
    },
    {
      "type": "TAX",
      "amount":
      {
        "value": "0",
        "currency": "GBP"
      }
    }]
  }],
  "merchant_preferences":
  {
    "setup_fee":
    {
      "value": "0",
      "currency": "GBP"
    },
    "return_url": "https://example.com/return",
    "cancel_url": "https://example.com/cancel",
    "auto_bill_amount": "YES",
    "initial_fail_amount_action": "CONTINUE",
    "max_fail_attempts": "0"
  }
}'
## ACTIVATE
curl -v -X PATCH https://api.sandbox.paypal.com/v1/payments/billing-plans/<PLAN_ID>/ \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer Access-Token" \
  -d '[{
  "op": "replace",
  "path": "/",
  "value":
  {
    "state": "ACTIVE"
  }
}]'
## CREATE AGREEMENT
curl -v -X POST https://api.sandbox.paypal.com/v1/payments/billing-agreements/ \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer Access-Token" \
  -d '{
  "name": "Premium Membership",
  "description": "Monthly agreement with a regular monthly payment definition and 1-week trial payment definition.",
  "start_date": "2019-01-22T09:13:49Z",
  "plan":
  {
    "id": "<PLAN_ID>"
  },
  "payer":
  {
    "payment_method": "paypal"
  }
}'
## GET CUSTOMER APPROVAL

## EXECUTE AN AGREEMENT

##
