import  { Router } from 'express';

import contactController from '../controllers/contact.js'; // Use import for ES modules

const router = Router()

// router.get('/', async (req,res) =>{
//     console.log(cache.contactCache.get(cache.cacheKey.contact))
// })

router.post('/add', async (req,res) => {
    await contactController.handleContactForm(req,res)
})

export default router;