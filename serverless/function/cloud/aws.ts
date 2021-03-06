import * as cdk from '@aws-cdk/core'
import * as iam from '@aws-cdk/aws-iam'
import * as lambda from '@aws-cdk/aws-lambda'
import * as logs from '@aws-cdk/aws-logs'
import { _, $ } from './pure'

function Lambda(parent: cdk.Construct): lambda.Function {
  return new lambda.Function(parent, 'APP',
    {
      description: 'APP Erlang AWS Lambda function',
      runtime: lambda.Runtime.PROVIDED,
      code: new lambda.AssetCode('../_build/default/bin'),
      handler: 'index.handler',
      timeout: cdk.Duration.seconds(10),
      memorySize: 256,
      layers: [
        lambda.LayerVersion.fromLayerVersionArn(parent, 'Layer', 
          `arn:aws:lambda:${cdk.Aws.REGION}:${cdk.Aws.ACCOUNT_ID}:layer:erlang-serverless:1`)
      ]
    }
  )
}

function Stack(stack: cdk.Construct): cdk.Construct {
  _(stack, Lambda)
  return stack
}

const app = new cdk.App()
_(app, Stack)
app.synth()