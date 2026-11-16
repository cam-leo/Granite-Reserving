# Python Basics

We are going to use Python Crash Course, 3rd edition by Eric Matthes to start with the basics and fundamentals of Python.

## Your first Python script

In your new python file, save this line. The `print()` function will display the text inside the quotation marks.

```python
print("Hello Actuary!")
```

When you run the python script, you should see this output.

```text
Hello Actuary!
```

What is happening when we run the program is that our editor (VScode) is running this file through the Python interpreter; this then reads through the program and determines what each words means

## Variables

We're going to add a new variable called "Leo".

```python
Leo = "Hello Actuary!"
print(Leo)
```

If you run this, you should see this output:

```text
Hello Actuary!
```

### Convention for Variables

Some guidelines to write code that is easy and nice to understand:

1. Variable names can only contain letters, numbers, underscores. They cannot start with a number
2. Spaces aren't able to be used but underscores can
3. Avoid using Python keywords and function names as variable names
4. Use short and descriptive names

Think of variables as labels that you can assign to values ie a variable references a certain value.

## Strings

Strings are series of characters. Whatever you put inside quotes is considered a string. You can use single or double quotes:

```python
print('"I told my friend, "Actuaries are actually really cool!"')
```

Next, [Excel to Python](excel-to-python.md) applies those ideas to a small claims dataset.
