# How to contribute

Contributions to InfrastructureAsCode are highly encouraged and desired.
Below are some guidelines that will help make the process as smooth as possible.

## Getting Started

- Submit a new issue, assuming one does not already exist.
  - Clearly describe the issue including steps to reproduce when it is a bug.
  - Make sure you fill in the earliest version that you know has the issue.

## Suggesting Enhancements

We want to know what you think is missing from InfrastructureAsCode and how it can be made better.

- When submitting an issue for an enhancement, please be as clear as possible about why you think the enhancement is needed and what the benefit of it would be.

## Making Changes

- Create a topic branch where work on your change will take place.
- To quickly create a topic branch based on master; `git checkout -b my_contribution master`. <br>
  We have policies in place to prevent direct committing on main to prevent error and malicious acts.
- Make commits of logical units.
- Check for unnecessary whitespace with `git diff --check` before committing.
- Check the build workflows when creating a PR. Our standards are added in CI as much as we can.
- Make sure your commit messages are in the proper format.

```
    Add more cowbell to Get-Something.ps1

    The functionality of Get-Something would be greatly improved if there was a little
    more 'pizzazz' added to it. I propose a cowbell. Adding more cowbell has been
    shown in studies to both increase one's work satisfaction, and cement one's status
    as a rock legend. We gotta have more cowbell!
```

- Make sure you have added all the necessary Pester tests for your changes.
- Run _all_ Pester tests in the module to assure nothing else was accidentally broken.

## Documentation

There is always something to improve in documentation. Please let us know via an issue or share a PR to improve our documentation.

## Submitting Changes

- Push your changes to a topic branch.
- Submit a pull request to the main branch.
- Once the pull request has been reviewed and accepted, it will be merged with the main branch.
- Celebrate 🎊

## Additional Resources

- [General GitHub documentation](https://help.github.com/)
- [GitHub forking documentation](https://guides.github.com/activities/forking/)
- [GitHub pull request documentation](https://help.github.com/send-pull-requests/)
- [GitHub Flow guide](https://guides.github.com/introduction/flow/)
- [GitHub's guide to contributing to open source projects](https://guides.github.com/activities/contributing-to-open-source/)
