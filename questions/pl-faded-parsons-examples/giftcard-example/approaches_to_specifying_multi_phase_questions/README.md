# How to specify multi-phase questions

I sought to find out what the most ergonomic way for an instructor to provide the necessary question code to create a multi-stage question. I attempted 3 approaches: 
1) the instructor creates a new question in a format very similar to before, where each question will have a self-contained delimination of lines provided as starting code along with possibly duplicate metadata about the question. (`approach_1/gift_card_*.yaml`)
    - Pros: 
        - Instructors can add variations to the problem statement to help elucidate the process to students (see the `prompt` in `approach_1/gift_card_2.yaml`)
        - The final state of the code that the student will see is clear when looking at the question summary (yaml file)
        - It is easy to create a mental model of what mutations are grouped with what tests the instructor would like to grade
        - This is likely the easiest/fastest to implement as an extension of `rspec-questionwriter`
    - Cons:
        - This approach is quite verbose, as there needs to be a new yaml file for each phase in the question
        - Changing a single variable name would require manually propagating that change in all phases of the question
        - Mutations used to grade multiple phases are specified multiple times (again, verbosity)
2) the instructor provides one yaml file that contains the student-facing code in all phases, each phase with entirely separate specification for each phase. (`approach_2/gift_card_list.yaml`)
    - Pros:
        - The final state of the code that the student will see is clear when looking at the question summary
        - The grouping of all student-facing content into one file can reduce instructor mental load when dealing with many multi-phase questions
        - Mutations may now be labeled with which phases they apply to, reducing verbosity in the question summary
        - Common prefacing prompt material is no longer duplicated in all files
    - Cons:
        - The question summary is exceedingly long and does not seem to reduce the verbosity in specifying student-facing code significantly from approach (1)
        - Changing a single variable name would still require manually propagating that change in all phases of the question
3) the instructor provides one yaml file that contains the aggregate student-facing code in all phases, with annotations to specifcy when a line of code is provided as fixed or manipulable code
    - Pros:
        - This is the least verbose possible representation of the question summary with no significant duplication of code
            - instructors can selectively duplicate code shown to the student in summaries
            - mutations can be labeled with which phases they apply to
            - the common prefacing question prompt is not duplicated
        - The grouping of all student-facing content into one file can reduce instructor mental load when dealing with many multi-phase questions
    - Cons:
        - The instructor-facing representation of the code can become very difficult to follow, especially in terms of how the student would see it
            - this can be solved technically, see `approach_3/display_phases.py`
        - The instructor must be very careful in annotating each line to generate the 
        