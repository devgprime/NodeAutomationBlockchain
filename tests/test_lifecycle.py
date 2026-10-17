import json
import os
from pathlib import Path
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]

class LifecycleTests(unittest.TestCase):
    def run_script(self, action, fail=""):
        with tempfile.TemporaryDirectory() as directory:
            d = Path(directory)
            tool = d / "terraform"
            tool.write_text("#!/usr/bin/env python3\nimport os,sys,json\nwith open(os.environ['CALL_LOG'],'a') as f: print(json.dumps({'args':sys.argv[1:],'cwd':os.getcwd()}),file=f)\nsys.exit(17 if sys.argv[1] == os.environ.get('FAIL_COMMAND') else 0)\n")
            tool.chmod(0o755)
            env = dict(os.environ, PATH=str(d)+os.pathsep+os.environ['PATH'], CALL_LOG=str(d/'calls'), FAIL_COMMAND=fail)
            result = subprocess.run(['bash', str(ROOT/'terraform'/f'{action}.sh'), '-var', 'label=two words'], cwd=d, env=env, text=True, capture_output=True)
            calls = [json.loads(line) for line in (d/'calls').read_text().splitlines()]
            return result, calls

    def test_apply_and_destroy_target_correct_command(self):
        for action in ('apply', 'destroy'):
            with self.subTest(action=action):
                result, calls = self.run_script(action)
                self.assertEqual(result.returncode, 0, result.stderr)
                self.assertEqual([c['args'] for c in calls], [['init'], [action, '-var', 'label=two words']])
                self.assertTrue(all(Path(c['cwd']) == ROOT/'terraform' for c in calls))

    def test_operation_failure_is_preserved(self):
        for action in ('apply', 'destroy'):
            result, calls = self.run_script(action, action)
            self.assertEqual(result.returncode, 17)
            self.assertNotIn('successfully', result.stdout)

    def test_init_failure_stops_before_operation(self):
        result, calls = self.run_script('apply', 'init')
        self.assertEqual(result.returncode, 17)
        self.assertEqual(len(calls), 1)
