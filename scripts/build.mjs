import { spawn } from 'node:child_process';
import path from 'node:path';

const siteRoot = path.resolve(process.cwd());

const steps = [
    {
        label: 'Build Hugo site',
        script: 'themes/banyan/scripts/build/run-hugo.mjs',
        args: ['--gc', '--cleanDestinationDir', '--minify']
    },
    {
        label: 'Patch CSP headers',
        script: 'themes/banyan/scripts/build/patch-csp.mjs'
    },
    {
        label: 'Emit Speculation-Rules headers',
        script: 'themes/banyan/scripts/build/emit-speculation-rules-headers.mjs'
    },
    {
        label: 'Sync EdgeOne config',
        script: 'themes/banyan/scripts/adapters/edgeone/sync-config.mjs'
    }
];

function runStep(step) {
    const scriptPath = path.join(siteRoot, step.script);
    const args = [scriptPath, ...(step.args ?? [])];

    console.log(`\n[build] ${step.label}`);

    return new Promise((resolve, reject) => {
        const child = spawn(process.execPath, args, {
            cwd: siteRoot,
            shell: false,
            stdio: 'inherit'
        });

        child.on('exit', (code, signal) => {
            if (signal) {
                reject(new Error(`${step.label} stopped by signal ${signal}.`));
                return;
            }
            if (code !== 0) {
                reject(new Error(`${step.label} failed with exit code ${code}.`));
                return;
            }
            resolve();
        });

        child.on('error', reject);
    });
}

for (const step of steps) {
    await runStep(step);
}
