# Deploy Runbook

## Before you start
- confirm the release tag
- check the staging smoke tests
- announce in the team channel

## Steps
1. drain the queue workers
2. run the database migration
3. deploy the API
4. deploy the web front end
5. re-enable the workers

## If it goes wrong
- the rollback command is below
- keep the previous release tag handy

## Rollback
- stop the workers again
- redeploy the previous tag
- verify the health endpoint

## After
- close the release ticket
- update the changelog
- thank whoever was on call
