from django.core.management.base import BaseCommand
from django.contrib.auth.models import Group, Permission
from django.core.management import call_command
from django.conf import settings
from django.contrib.auth.models import User


class Command(BaseCommand):
    help = "Add groups to sample users, "

    def handle(self, *args, **options):
        write = print
        build_group_command = "build_groups_and_permissions"
        write("run {command_name}".format(command_name=build_group_command))
        call_command(build_group_command,)

        self.add_test_user_into_group(settings.SAMPLE_PARENT_USER_FORMULA, settings.SAMPLE_DATA_LENGTH, '家长')

        self.add_test_user_into_group(settings.SAMPLE_TEACHER_USER_FORMULA, settings.SAMPLE_DATA_LENGTH, '老师')

    def add_test_user_into_group(self, test_user_format, count, group_name):
        print("add "+group_name+"测试用户 into Group of "+group_name+"...")
        user_group = Group.objects.get(name=group_name)
        for i in range(count):
            username = test_user_format.format(id=i)
            try:
                user = User.objects.get(username=username)
            except User.DoesNotExist:
                print("{user} not exist".format(test_user_format))
                continue
            user.groups.add(user_group)
            user.save()
            print("{user} added {group}".format(user=user, group=user_group))
        print("add "+group_name+"测试用户 into Group of "+group_name+" end.")
