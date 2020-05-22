## Server-side Swift development for Amazon Linux 2 using an AWS CI/CD pipeline

This project is the accompanying source code to the blog article locate here: https://aws.amazon.com/blogs/opensource/continuous-delivery-with-server-side-swift-on-amazon-linux-2/. Please check that article out - it goes over the project goals and setup instructions in much greater depth.

## Getting started

 1. Create a new S3 bucket that will store your packaged cloudformation templates, or find an existing one to use. The user running the scripts should have read/write access to this bucket, and it should be in the same account as where you want the resources to be provisioned.
 2. Update package.json with the name of the bucket. The scripts should have the CF_BUCKET environment variable set to the name of the bucket.
 3. Optionally, update `create-stack.json` and update the tags applied to the resources, or the name of the cloudformation stack.
 4. Run `npm run-scripts create`
 5. Wait for the script to finish. You can view the status either by looking at the AWS console in the Cloudformation section or by running `aws cloudformation wait stack-create-complete`
 6. Create the docker image. Navigate to `ECR` within the AWS console, click on `codebuild/swift` and follow the instructions in `View push commands` from within the `codebuild-image` folder.
 7. Copy the contents of the `app` folder to another directory: `cp -r ./app ../swift-codebuild-app`.
 8. Change to the newly copied directory and initialize a git repository: `cd ../swift-codebuild-app && git init`
 9. Navigate to the `CodeCommit` AWS console, then locate the repository created by the Cloudformation script (it should start with the stack name that you used). Click on that repository and follow the instructions to initialize the repository with the contents of `swift-codebuild-app`.
 10. Navigate to CodePipeline. Click on the pipeline whose name starts with the Cloudformation stack name. After a few seconds it should pick up the change in the CodeCommit repository and launch. After 10-15 minutes it should complete all three stages: Source, Build, and Release.
 11. Navigate to the EC2 AWS console, then click on the sidebar to find the `Load Balancer` section. First click on the load balancer whose name starts with `swift-EC2`. Copy the DNS name and paste it into a browser window. Confirm that it reponds with "It works!"
 12. Update the `swift-codebuild-app` repository. Edit `Sources/App/routes.swift` and modify `return "It works!"` to read `return "It works! With an update!"`. Commit those changes and push them to the CodeCommit repository.
 13. Wait for the pipeline to update and confirm that the two load balancers update with the correct message.

 ## License

This library is licensed under the MIT-0 License. See the LICENSE file.
