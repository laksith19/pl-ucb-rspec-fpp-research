This is a copy of https://github.com/ace-lab/pl-ucb-csxxx used to develop FPP questions for software testing with rspec. The rest of the readme/contents is unchanged.

# Starting PL with autograder support

```
sudo docker run -it --rm \
    -p 3000:3000 \
    -v "$HOME/pl_ag_jobs":"/jobs" \
    -e HOST_JOBS_DIR="$HOME/pl_ag_jobs" \
    -v `pwd`:/course \
    -v /var/run/docker.sock:/var/run/docker.sock \
    prairielearn/prairielearn:latest
```

