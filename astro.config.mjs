// @ts-check
import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

export default defineConfig({
  site: 'https://cmsc398w.github.io',
  base: '/course_docs',
  integrations: [
    starlight({
      title: 'CMSC398W',
      description: 'Practical Tools for Efficient Development',
      sidebar: [
        { label: 'Syllabus', link: '/syllabus/' },
        {
          label: 'Slides',
          items: [
            { label: 'The Shell', link: '/slides/the-shell/' },
            { label: 'Git', link: '/slides/git/' },
            { label: 'CI / Build Systems', link: '/slides/ci/' },
            { label: 'Debugging & Profiling', link: '/slides/debugging/' },
            { label: 'Docker', link: '/slides/docker/' },
            { label: 'Networking', link: '/slides/networking/' },
            { label: 'ML / AI Tools', link: '/slides/ml-ai/' },
          ],
        },
        {
          label: 'Application Days',
          items: [
            { label: 'Shell Application Day', link: '/application-days/shell/' },
            { label: 'Git Application Day', link: '/application-days/git/' },
            { label: 'Docker Application Day', link: '/application-days/docker/' },
          ],
        },
        {
          label: 'Projects',
          items: [
            { label: 'Overview', link: '/projects/' },
            { label: 'System Monitoring Dashboard', link: '/projects/system-monitoring/' },
            { label: 'Git Part 1', link: '/projects/git-part-1/' },
            { label: 'Git Part 2', link: '/projects/git-part-2/' },
            { label: 'Networking Project', link: '/projects/networking/' },
          ],
        },
        {
          label: 'Info',
          items: [
            { label: 'Info', link: '/info/' },
            { label: 'Build Setup', link: '/info/build-setup/' },
          ],
        },
      ],
    }),
  ],
});
