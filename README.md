# mampenv - PHP CLI multi-version management for MAMP

I've historically had trouble with getting [phpenv](https://github.com/phpenv/phpenv) to successfully build certain versions of PHP on my Mac, so I started using the versions that were distributed by [MAMP](https://www.mamp.info/en/mamp/mac/). mampenv is here to help you switch between MAMP's PHP versions just like [phpenv](https://github.com/phpenv/phpenv) and [rbenv](https://github.com/sstephenson/rbenv). Put a `.php-version` file in the root of your project folder and have the peace of mind of knowing that your PHP CLI version will remain consistent.

## Key features:

* Run MAMP-supported PHP versions directly from the command line
* Run `composer` using the correct PHP version
* Use project-specific versions of MAMP's PHP installations
* PEAR? PECL? Oh yes, each MAMP version of PHP already has that

## How It Works

mampenv operates on the per-user directory `~/.mampenv`. This directory contains shim-style scripts that take over the `php` and `composer` commands on the command line. It will make sure they are executed using the PHP version in the following order:

1. Specified in your project folder's `.php-version` file, if one is present
2. Specified in `~/.mampenv/version`
3. The system default PHP version, if one is present

Each MAMP PHP version is a stand-alone installation with its own binaries and configuration.

## Installation

This will get you going with the latest version of mampenv and make it
easy to fork and contribute any changes back upstream.

1. Check out mampenv into `~/.mampenv`.

   ```bash
   cd
   git clone https://github.com/allejo/mampenv.git ~/.mampenv
   ```

2. Add `~/.mampenv/bin` to your `$PATH` for access to the `mampenv` command-line utility. In your shell's profile file (e.g. `~/.bash_profile` or `~/.zshrc`), add the following line:

   ```bash
   export PATH="$HOME/.mampenv/bin:$PATH"
   ```

3. Restart your shell so the path changes take effect or `source` your profile file.

   ```bash
   source ~/.zshrc
   ```

4. If all goes well, `which php` should indicate a `~/.mampenv/bin/php` path. `which composer` should say `~/.mampenv/bin/composer` and `which pecl` should say `~/.mampenv/bin/pecl`.

### Upgrading

If you've installed mampenv using the instructions above, you can
upgrade your installation at any time using git. To upgrade to the latest development version of mampenv, use `git pull`:

```bash
cd ~/.mampenv
git pull
```

## Usage

Like `git`, the `mampenv` command delegates to subcommands based on its first argument. The most common subcommands are:

### `versions`

List the local MAMP PHP versions installed.

```bash
mampenv versions
```

### `local [version]`

Create a new `.php-version` file in the current directory.

```bash
# Display the version configured in a `.php-version`
mampenv local

# Set the version to use in the current directory
mampenv local 7.1.0
```

### `global [version]`

Create or display the global PHP value in `~/.mampenv/version`.

```bash
# Display the global version
mampenv global

# Set the global version to use
mampenv global 7.1.0
```

## License

[MIT License](./LICENSE)
